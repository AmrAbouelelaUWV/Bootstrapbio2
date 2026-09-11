# xx-azurerm-vms

Terraform module for hardened Azure management VMs.

This module is provider-specific and encodes management VM mechanics. It is not
a generic wrapper around `azurerm_linux_virtual_machine` or
`azurerm_windows_virtual_machine`.

## Contract

Creates Linux and Windows management VMs with:

- one private NIC per VM
- no public IP resources
- system-assigned managed identity
- encryption at host
- boot diagnostics
- Entra login VM extension
- source image ID or source image reference
- required BIV tag

PIM, RBAC, Bastion, naming policy, subnet selection, and customer-specific group
wiring belong in the consuming stack.

## Usage

```hcl
variable "windows_admin_password" {
  description = "Windows admin password from a secret source."
  type        = string
  sensitive   = true
}

module "vms" {
  source = "git::ssh://git@github.com/jacquelinep777/xx-azurerm-vms.git?ref=v0.1.0"

  resource_group_name = "rg-management-dev-we-01"
  location            = "westeurope"
  biv                 = "233"

  admin_passwords = {
    windows = var.windows_admin_password
  }

  vms = {
    linux = {
      name                 = "vm-linux-management-dev-we-01"
      nic_name             = "nic-linux-management-dev-we-01"
      os_type              = "linux"
      subnet_id            = module.network.subnet_ids["snet-management-dev-we-01"]
      size                 = "Standard_B2s"
      admin_username       = "azureadmin"
      admin_ssh_public_key = var.admin_ssh_public_key
      source_image_reference = {
        publisher = "Canonical"
        offer     = "ubuntu-24_04-lts"
        sku       = "server"
        version   = "latest"
      }
    }

    windows = {
      name           = "vm-windows-management-dev-we-01"
      nic_name       = "nic-windows-management-dev-we-01"
      os_type        = "windows"
      subnet_id      = module.network.subnet_ids["snet-management-dev-we-01"]
      size           = "Standard_B2s"
      admin_username = "zauadmin"
      source_image_reference = {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2022-datacenter-azure-edition"
        version   = "latest"
      }
    }
  }
}
```

For sys-hardened images, set `source_image_id` to the approved Shared Image
Gallery image version ID and omit `source_image_reference`.

## Development

```bash
make fmt
make validate
make lint
make test
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

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_linux_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_virtual_machine_extension.entra_login_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.entra_login_windows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_admin_passwords"></a> [admin\_passwords](#input\_admin\_passwords) | Windows admin passwords keyed by VM logical name. Supply from a secret source, not tfvars. | `map(string)` | `{}` | no |
| <a name="input_biv"></a> [biv](#input\_biv) | Security classification tag, beschikbaarheid-integriteit-vertrouwelijkheid, 1=high 2=medium 3=low. | `string` | n/a | yes |
| <a name="input_boot_diagnostics_storage_account_uri"></a> [boot\_diagnostics\_storage\_account\_uri](#input\_boot\_diagnostics\_storage\_account\_uri) | Optional storage account URI for boot diagnostics. Null uses managed boot diagnostics. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for the virtual machines. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group where the virtual machines are created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags. The module-owned biv tag takes precedence. | `map(string)` | `{}` | no |
| <a name="input_vms"></a> [vms](#input\_vms) | Management VMs keyed by logical name. Supports Linux and Windows VMs. | <pre>map(object({<br/>    name                 = string<br/>    nic_name             = string<br/>    os_type              = string<br/>    subnet_id            = string<br/>    size                 = optional(string, "Standard_B2s")<br/>    admin_username       = optional(string, "azureadmin")<br/>    admin_ssh_public_key = optional(string)<br/>    source_image_id      = optional(string)<br/>    source_image_reference = optional(object({<br/>      publisher = string<br/>      offer     = string<br/>      sku       = string<br/>      version   = string<br/>    }))<br/>    plan = optional(object({<br/>      name      = string<br/>      product   = string<br/>      publisher = string<br/>    }))<br/>    os_disk = optional(object({<br/>      caching              = optional(string, "ReadWrite")<br/>      storage_account_type = optional(string, "StandardSSD_LRS")<br/>    }), {})<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_network_interface_ids"></a> [network\_interface\_ids](#output\_network\_interface\_ids) | Network interface IDs keyed by logical name. |
| <a name="output_principal_ids"></a> [principal\_ids](#output\_principal\_ids) | System-assigned managed identity principal IDs keyed by logical name. |
| <a name="output_private_ip_addresses"></a> [private\_ip\_addresses](#output\_private\_ip\_addresses) | Private IP addresses keyed by logical name. |
| <a name="output_vm_ids"></a> [vm\_ids](#output\_vm\_ids) | Virtual machine IDs keyed by logical name. |
| <a name="output_vm_names"></a> [vm\_names](#output\_vm\_names) | Virtual machine names keyed by logical name. |
<!-- END_TF_DOCS -->
