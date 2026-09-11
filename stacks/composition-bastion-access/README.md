# xx-azurerm-stack-bastion-access

Terraform foundation stack for company-standard Azure Bastion access.

This stack creates a dedicated Bastion VNet and peers it to a target VNet. It
encodes the reusable secure access pattern from the working implementation so
product stacks do not duplicate Bastion rules.

## Usage

```hcl
module "bastion_access" {
  source = "git::ssh://git@github.com/jacquelinep777/xx-azurerm-stack-bastion-access.git?ref=v0.0.1"

  workload    = "management"
  environment = "dev"
  location    = "westeurope"
  region_code = "we"
  instance    = "01"
  biv         = "233"

  address_space          = ["10.90.0.0/24"]
  bastion_subnet_prefix  = "10.90.0.0/26"
  target_virtual_network_id                  = module.network.id
  target_virtual_network_name                = module.network.name
  target_virtual_network_resource_group_name = "rg-management-dev-we-01"
}
```

## Development

```bash
make fmt
make validate
make lint
make test
make policy
make scan
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

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_network"></a> [network](#module\_network) | git::ssh://git@github.com-jacquelinep777/jacquelinep777/xx-azurerm-network.git | v0.1.2 |

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_bastion_host.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_virtual_network_peering.target_to_bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | Address space for the dedicated Bastion VNet. | `list(string)` | n/a | yes |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Availability zones for the Bastion public IP. | `list(string)` | <pre>[<br/>  "1",<br/>  "2",<br/>  "3"<br/>]</pre> | no |
| <a name="input_bastion_sku"></a> [bastion\_sku](#input\_bastion\_sku) | Azure Bastion SKU. Basic and Standard are supported by this stack. | `string` | `"Basic"` | no |
| <a name="input_bastion_subnet_prefix"></a> [bastion\_subnet\_prefix](#input\_bastion\_subnet\_prefix) | CIDR prefix for AzureBastionSubnet. Basic and Standard Bastion require /26 or larger. | `string` | n/a | yes |
| <a name="input_biv"></a> [biv](#input\_biv) | Security classification tag, beschikbaarheid-integriteit-vertrouwelijkheid, 1=high 2=medium 3=low. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment code, for example dev, acc, or prd. | `string` | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | Two digit resource instance number. | `string` | `"01"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region name. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | Optional Log Analytics workspace ID for Bastion diagnostics. | `string` | `null` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short region code, for example we, ne, or eus. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags. Stack-owned required tags take precedence. | `map(string)` | `{}` | no |
| <a name="input_target_peering_name"></a> [target\_peering\_name](#input\_target\_peering\_name) | Peering name from the Bastion VNet to the target VNet. | `string` | `"peer-bastion-to-target"` | no |
| <a name="input_target_reverse_peering_name"></a> [target\_reverse\_peering\_name](#input\_target\_reverse\_peering\_name) | Peering name from the target VNet to the Bastion VNet. | `string` | `"peer-target-to-bastion"` | no |
| <a name="input_target_virtual_network_id"></a> [target\_virtual\_network\_id](#input\_target\_virtual\_network\_id) | Target VNet ID that the Bastion access VNet peers to. | `string` | n/a | yes |
| <a name="input_target_virtual_network_name"></a> [target\_virtual\_network\_name](#input\_target\_virtual\_network\_name) | Target VNet name for the reverse peering. | `string` | n/a | yes |
| <a name="input_target_virtual_network_resource_group_name"></a> [target\_virtual\_network\_resource\_group\_name](#input\_target\_virtual\_network\_resource\_group\_name) | Resource group containing the target VNet for the reverse peering. | `string` | n/a | yes |
| <a name="input_workload"></a> [workload](#input\_workload) | Short workload name used in resource names. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_bastion_id"></a> [bastion\_id](#output\_bastion\_id) | Azure Bastion host ID. |
| <a name="output_bastion_name"></a> [bastion\_name](#output\_bastion\_name) | Azure Bastion host name. |
| <a name="output_bastion_subnet_id"></a> [bastion\_subnet\_id](#output\_bastion\_subnet\_id) | AzureBastionSubnet ID. |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | Dedicated Bastion VNet ID. |
| <a name="output_public_ip_id"></a> [public\_ip\_id](#output\_public\_ip\_id) | Bastion public IP ID. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Bastion access resource group name. |
<!-- END_TF_DOCS -->
