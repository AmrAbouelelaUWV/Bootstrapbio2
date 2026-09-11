terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26"
    }
  }
}

module "bastion_access" {
  source = "../.."

  workload    = "management"
  environment = "dev"
  location    = "westeurope"
  region_code = "we"
  instance    = "01"
  biv         = "233"

  address_space                              = ["10.91.0.0/24"]
  bastion_subnet_prefix                      = "10.91.0.0/26"
  target_virtual_network_id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-management-dev-we-01/providers/Microsoft.Network/virtualNetworks/vnet-management-dev-we-01"
  target_virtual_network_name                = "vnet-management-dev-we-01"
  target_virtual_network_resource_group_name = "rg-management-dev-we-01"
}
