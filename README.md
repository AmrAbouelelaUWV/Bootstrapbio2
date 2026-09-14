# xx-azurerm-stack-jumphost

Terraform stack for the Azure jumphost golden path.

This stack composes the workload network, Bastion access foundation stack, and
VM module. It applies company naming and wires VM access assignments. It is not
a low-level module.

## Contract

Creates:

- resource group
- jumphost virtual network
- management subnet
- management subnet NSG and association through `xx-azurerm-network`
- dedicated Bastion access VNet, `AzureBastionSubnet`, public IP, host, and
  VNet peering through `xx-azurerm-stack-bastion-access`
- hardened Linux and/or Windows management VMs through `xx-azurerm-vms`
- VM login RBAC assignments
- optional PIM eligible VM login assignments

The stack owns product-specific choices. The network and VM modules stay
generic and reusable.

## Usage

```hcl
variable "admin_ssh_public_key" {
  description = "Linux admin SSH public key."
  type        = string
}

variable "windows_admin_password" {
  description = "Windows admin password from a secret source."
  type        = string
  sensitive   = true
}

module "jumphost" {
  source = "git::ssh://git@github.com/nluwv/AZLABS-cnc-azurerm-composition-jumphost.git?ref=v0.0.2"

  workload    = "management"
  environment = "dev"
  location    = "westeurope"
  region_code = "we"
  instance    = "01"
  biv         = "233"

  address_space            = ["10.10.0.0/16"]
  management_subnet_prefix = "10.10.1.0/24"
  bastion_address_space    = ["10.90.0.0/24"]
  bastion_subnet_prefix    = "10.90.0.0/26"

  linux_vm = {
    admin_username       = "azureadmin"
    admin_ssh_public_key = var.admin_ssh_public_key
    source_image_reference = {
      publisher = "Canonical"
      offer     = "ubuntu-24_04-lts"
      sku       = "server"
      version   = "latest"
    }
  }

  windows_vm = {
    admin_username = "zauadmin"
    source_image_reference = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-datacenter-azure-edition"
      version   = "latest"
    }
  }

  admin_passwords = {
    windows = var.windows_admin_password
  }

  admin_login_principal_ids = {
    platform-admins = "00000000-0000-0000-0000-000000000001"
  }

  user_login_principal_ids = {
    platform-readers = "00000000-0000-0000-0000-000000000002"
  }

  enable_pim_eligible_role_assignments = true
}
```

For sys-hardened images, set `linux_vm.source_image_id` and/or
`windows_vm.source_image_id` to approved Shared Image Gallery image version IDs
and omit the corresponding `source_image_reference`.

## Development

This repo pins private module sources by exact git tag:

- `AZLABS-cnc-azurerm-network.git?ref=v0.1.2`
- `AZLABS-cnc-azurerm-composition-bastion-access.git?ref=v0.0.2`
- `AZLABS-cnc-azurerm-vms.git?ref=v0.1.1`

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
| <a name="module_bastion_access"></a> [bastion\_access](#module\_bastion\_access) | git::ssh://git@github.com/nluwv/AZLABS-cnc-azurerm-composition-bastion-access.git | v0.0.2 |
| <a name="module_network"></a> [network](#module\_network) | git::ssh://git@github.com/nluwv/AZLABS-cnc-azurerm-network.git | v0.1.2 |
| <a name="module_vms"></a> [vms](#module\_vms) | git::ssh://git@github.com/nluwv/AZLABS-cnc-azurerm-vms.git | v0.1.1 |

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_pim_eligible_role_assignment.vm_admin_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/pim_eligible_role_assignment) | resource |
| [azurerm_pim_eligible_role_assignment.vm_user_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/pim_eligible_role_assignment) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.vm_admin_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.vm_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.vm_user_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.pim_vm_admin_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.pim_vm_user_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | Virtual network address spaces for the jumphost network. | `list(string)` | n/a | yes |
| <a name="input_admin_login_principal_ids"></a> [admin\_login\_principal\_ids](#input\_admin\_login\_principal\_ids) | Principal IDs keyed by group or principal name for Virtual Machine Administrator Login on all management VMs. | `map(string)` | `{}` | no |
| <a name="input_admin_passwords"></a> [admin\_passwords](#input\_admin\_passwords) | Windows admin passwords keyed by VM logical name. Supply from a secret source, not tfvars. | `map(string)` | `{}` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Availability zones for the Bastion public IP. | `list(string)` | <pre>[<br/>  "1",<br/>  "2",<br/>  "3"<br/>]</pre> | no |
| <a name="input_bastion_address_space"></a> [bastion\_address\_space](#input\_bastion\_address\_space) | Address space for the dedicated Bastion access VNet. | `list(string)` | n/a | yes |
| <a name="input_bastion_log_analytics_workspace_id"></a> [bastion\_log\_analytics\_workspace\_id](#input\_bastion\_log\_analytics\_workspace\_id) | Optional Log Analytics workspace ID for Bastion diagnostics. | `string` | `null` | no |
| <a name="input_bastion_sku"></a> [bastion\_sku](#input\_bastion\_sku) | Azure Bastion SKU. Basic and Standard are supported by this stack. | `string` | `"Basic"` | no |
| <a name="input_bastion_subnet_prefix"></a> [bastion\_subnet\_prefix](#input\_bastion\_subnet\_prefix) | CIDR prefix for AzureBastionSubnet in the dedicated Bastion access VNet. Basic and Standard Bastion require /26 or larger. | `string` | n/a | yes |
| <a name="input_biv"></a> [biv](#input\_biv) | Security classification tag, beschikbaarheid-integriteit-vertrouwelijkheid, 1=high 2=medium 3=low. | `string` | n/a | yes |
| <a name="input_enable_linux_vm"></a> [enable\_linux\_vm](#input\_enable\_linux\_vm) | When true, create the Linux management VM. | `bool` | `true` | no |
| <a name="input_enable_pim_eligible_role_assignments"></a> [enable\_pim\_eligible\_role\_assignments](#input\_enable\_pim\_eligible\_role\_assignments) | When true, create PIM eligible VM login role assignments. | `bool` | `false` | no |
| <a name="input_enable_windows_vm"></a> [enable\_windows\_vm](#input\_enable\_windows\_vm) | When true, create the Windows management VM. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment code, for example dev, acc, or prd. | `string` | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | Two digit resource instance number. | `string` | `"01"` | no |
| <a name="input_linux_vm"></a> [linux\_vm](#input\_linux\_vm) | Linux management VM configuration. | <pre>object({<br/>    size                 = optional(string, "Standard_B2s")<br/>    admin_username       = optional(string, "azureadmin")<br/>    admin_ssh_public_key = optional(string)<br/>    source_image_id      = optional(string)<br/>    source_image_reference = optional(object({<br/>      publisher = string<br/>      offer     = string<br/>      sku       = string<br/>      version   = string<br/>      }), {<br/>      publisher = "Canonical"<br/>      offer     = "ubuntu-24_04-lts"<br/>      sku       = "server"<br/>      version   = "latest"<br/>    })<br/>    os_disk = optional(object({<br/>      caching              = optional(string, "ReadWrite")<br/>      storage_account_type = optional(string, "StandardSSD_LRS")<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region name. | `string` | n/a | yes |
| <a name="input_management_subnet_prefix"></a> [management\_subnet\_prefix](#input\_management\_subnet\_prefix) | CIDR prefix for the management VM subnet. | `string` | n/a | yes |
| <a name="input_pim_eligible_assignment_duration_days"></a> [pim\_eligible\_assignment\_duration\_days](#input\_pim\_eligible\_assignment\_duration\_days) | Duration in days for PIM eligible role assignments. | `number` | `365` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short region code, for example we, ne, or eus. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags. Stack-owned required tags take precedence. | `map(string)` | `{}` | no |
| <a name="input_user_login_principal_ids"></a> [user\_login\_principal\_ids](#input\_user\_login\_principal\_ids) | Principal IDs keyed by group or principal name for Virtual Machine User Login on all management VMs. | `map(string)` | `{}` | no |
| <a name="input_windows_vm"></a> [windows\_vm](#input\_windows\_vm) | Windows management VM configuration. | <pre>object({<br/>    size            = optional(string, "Standard_B2s")<br/>    admin_username  = optional(string, "zauadmin")<br/>    source_image_id = optional(string)<br/>    source_image_reference = optional(object({<br/>      publisher = string<br/>      offer     = string<br/>      sku       = string<br/>      version   = string<br/>      }), {<br/>      publisher = "MicrosoftWindowsServer"<br/>      offer     = "WindowsServer"<br/>      sku       = "2022-datacenter-azure-edition"<br/>      version   = "latest"<br/>    })<br/>    plan = optional(object({<br/>      name      = string<br/>      product   = string<br/>      publisher = string<br/>    }))<br/>    os_disk = optional(object({<br/>      caching              = optional(string, "ReadWrite")<br/>      storage_account_type = optional(string, "StandardSSD_LRS")<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Short workload name used in resource names. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_bastion_id"></a> [bastion\_id](#output\_bastion\_id) | Azure Bastion host ID. |
| <a name="output_bastion_name"></a> [bastion\_name](#output\_bastion\_name) | Azure Bastion host name. |
| <a name="output_bastion_public_ip_id"></a> [bastion\_public\_ip\_id](#output\_bastion\_public\_ip\_id) | Bastion public IP resource ID. |
| <a name="output_linux_bastion_ssh_command"></a> [linux\_bastion\_ssh\_command](#output\_linux\_bastion\_ssh\_command) | Azure CLI command for SSH to the Linux VM through Bastion. |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | Jumphost virtual network ID. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Resource group name. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Subnet IDs keyed by subnet name. |
| <a name="output_vm_ids"></a> [vm\_ids](#output\_vm\_ids) | Management VM IDs keyed by logical name. |
| <a name="output_vm_private_ip_addresses"></a> [vm\_private\_ip\_addresses](#output\_vm\_private\_ip\_addresses) | Management VM private IP addresses keyed by logical name. |
<!-- END_TF_DOCS -->
