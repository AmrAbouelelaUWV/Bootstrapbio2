terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26"
    }
  }
}

variable "admin_ssh_public_key" {
  description = "Linux admin SSH public key."
  type        = string
}

variable "windows_admin_password" {
  description = "Windows admin password from a secret source."
  type        = string
  sensitive   = true
}

module "this" {
  source = "../.."

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
      subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-management-dev-we-01/providers/Microsoft.Network/virtualNetworks/vnet-management-dev-we-01/subnets/snet-management-dev-we-01"
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
      subnet_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-management-dev-we-01/providers/Microsoft.Network/virtualNetworks/vnet-management-dev-we-01/subnets/snet-management-dev-we-01"
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
