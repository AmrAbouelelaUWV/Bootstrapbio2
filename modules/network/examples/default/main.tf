terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26"
    }
  }
}

provider "azurerm" {
  features {}
}

module "this" {
  source = "../.."

  name                = "vnet-network-dev-we-01"
  resource_group_name = "rg-network-dev-we-01"
  location            = "westeurope"
  address_space       = ["10.0.0.0/16"]
  biv                 = "333"

  subnets = {
    "snet-workload-01" = {
      address_prefixes = ["10.0.1.0/24"]
    }
  }

  network_security_groups = {
    "nsg-workload-01" = {
      subnet_name = "snet-workload-01"
      security_rules = {
        "AllowHttpsOutbound" = {
          priority                     = 100
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_ranges           = ["*"]
          destination_port_ranges      = ["443"]
          source_address_prefixes      = ["*"]
          destination_address_prefixes = ["Internet"]
        }
      }
    }
  }

  route_tables = {
    "rt-workload-01" = {
      bgp_route_propagation_enabled = false
      routes = {
        default = {
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.0.0.4"
        }
      }
    }
  }

  route_table_associations = {
    "snet-workload-01" = {
      route_table_name = "rt-workload-01"
    }
  }
}
