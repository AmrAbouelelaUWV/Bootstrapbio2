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

module "jumphost" {
  source = "../.."

  workload    = "management"
  environment = "dev"
  location    = "westeurope"
  region_code = "we"
  instance    = "01"
  biv         = "233"

  address_space            = ["10.20.0.0/16"]
  management_subnet_prefix = "10.20.1.0/24"
  bastion_address_space    = ["10.91.0.0/24"]
  bastion_subnet_prefix    = "10.91.0.0/26"

  linux_vm = {
    admin_username       = "azureadmin"
    admin_ssh_public_key = var.admin_ssh_public_key
  }

  windows_vm = {
    admin_username = "zauadmin"
  }

  admin_passwords = {
    windows = var.windows_admin_password
  }
}
