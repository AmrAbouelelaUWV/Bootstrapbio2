# xx-azurerm-network

Terraform module for Azure network foundation.

This module is provider-specific and should encode a reusable platform concept,
not wrap a single Terraform resource type.

## Contract

Creates an Azure virtual network, subnets, optional NSGs, optional NSG
associations, optional route tables, optional routes, optional VNet peerings,
and optional private DNS zone links.

This module is used by both connected and disconnected routes:

- Connected route: usually not used directly; stacks consume the supplied network
  through explicit input values or data sources.
- Disconnected route: create the subscription network foundation.

## Usage

```hcl
module "network" {
  source = "git::ssh://git@github.com/jacquelinep777/xx-azurerm-network.git?ref=v0.0.2"

  name                = "vnet-app-dev-we-01"
  resource_group_name = "rg-app-dev-we-01"
  location            = "westeurope"
  address_space       = ["10.10.0.0/16"]
  biv                 = "233"

  subnets = {
    "snet-workload-app-dev-we-01" = {
      address_prefixes = ["10.10.1.0/24"]
    }
  }

  route_tables = {
    "rt-workload-app-dev-we-01" = {
      bgp_route_propagation_enabled = false
      routes = {
        default = {
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = var.firewall_ip
        }
      }
    }
  }

  route_table_associations = {
    "snet-workload-app-dev-we-01" = {
      route_table_name = "rt-workload-app-dev-we-01"
    }
  }

  peerings = {
    "peer-to-hub" = {
      remote_virtual_network_id = var.hub_vnet_id
      allow_forwarded_traffic   = true
      use_remote_gateways       = true
    }
  }
}
```

## Development

```bash
make fmt
make validate
make lint
make test
make scan
make docs
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.26 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.81.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_private_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_route_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | Virtual network address spaces. | `list(string)` | n/a | yes |
| <a name="input_biv"></a> [biv](#input\_biv) | Security classification tag, beschikbaarheid-integriteit-vertrouwelijkheid, 1=high 2=medium 3=low. | `string` | n/a | yes |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | Optional custom DNS servers for the virtual network. | `list(string)` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for the virtual network. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Virtual network name. | `string` | n/a | yes |
| <a name="input_network_security_groups"></a> [network\_security\_groups](#input\_network\_security\_groups) | Network security groups keyed by NSG name. Each NSG attaches to one subnet. | <pre>map(object({<br/>    subnet_name = string<br/>    security_rules = map(object({<br/>      priority                     = number<br/>      direction                    = string<br/>      access                       = string<br/>      protocol                     = string<br/>      source_port_ranges           = list(string)<br/>      destination_port_ranges      = list(string)<br/>      source_address_prefixes      = list(string)<br/>      destination_address_prefixes = list(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_peerings"></a> [peerings](#input\_peerings) | Outbound virtual network peerings from this VNet keyed by peering name. | <pre>map(object({<br/>    remote_virtual_network_id    = string<br/>    allow_virtual_network_access = optional(bool, true)<br/>    allow_forwarded_traffic      = optional(bool, false)<br/>    allow_gateway_transit        = optional(bool, false)<br/>    use_remote_gateways          = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_private_dns_zones"></a> [private\_dns\_zones](#input\_private\_dns\_zones) | Private DNS zones keyed by zone name and linked to this virtual network. | <pre>map(object({<br/>    link_name            = string<br/>    registration_enabled = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group where the virtual network is created. | `string` | n/a | yes |
| <a name="input_route_table_associations"></a> [route\_table\_associations](#input\_route\_table\_associations) | Route table associations keyed by subnet name. | <pre>map(object({<br/>    route_table_name = string<br/>  }))</pre> | `{}` | no |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | Route tables keyed by route table name. | <pre>map(object({<br/>    bgp_route_propagation_enabled = optional(bool, true)<br/>    routes = optional(map(object({<br/>      address_prefix         = string<br/>      next_hop_type          = string<br/>      next_hop_in_ip_address = optional(string)<br/>    })), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets keyed by subnet name. | <pre>map(object({<br/>    address_prefixes  = list(string)<br/>    service_endpoints = optional(list(string), [])<br/>    delegations = optional(map(object({<br/>      service_name = string<br/>      actions      = list(string)<br/>    })), {})<br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags. The module-owned biv tag takes precedence. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | Virtual network ID. |
| <a name="output_name"></a> [name](#output\_name) | Virtual network name. |
| <a name="output_network_security_group_ids"></a> [network\_security\_group\_ids](#output\_network\_security\_group\_ids) | Network security group IDs keyed by NSG name. |
| <a name="output_peering_ids"></a> [peering\_ids](#output\_peering\_ids) | Virtual network peering IDs keyed by peering name. |
| <a name="output_private_dns_zone_ids"></a> [private\_dns\_zone\_ids](#output\_private\_dns\_zone\_ids) | Private DNS zone IDs keyed by zone name. |
| <a name="output_route_table_ids"></a> [route\_table\_ids](#output\_route\_table\_ids) | Route table IDs keyed by route table name. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Subnet IDs keyed by subnet name. |
| <a name="output_subnet_names"></a> [subnet\_names](#output\_subnet\_names) | Subnet names keyed by subnet name. |
<!-- END_TF_DOCS -->
