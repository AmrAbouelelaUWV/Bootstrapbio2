mock_provider "azurerm" {}

variables {
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

  peerings = {
    "peer-to-hub" = {
      remote_virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-hub-dev-we-01/providers/Microsoft.Network/virtualNetworks/vnet-hub-dev-we-01"
      allow_forwarded_traffic   = true
      use_remote_gateways       = true
    }
  }
}

run "accepts_valid_contract" {
  command = plan
}

run "creates_virtual_network" {
  command = plan

  assert {
    condition     = azurerm_virtual_network.this.name == "vnet-network-dev-we-01"
    error_message = "Virtual network name must come from var.name."
  }
}

run "applies_biv_tag" {
  command = plan

  assert {
    condition     = azurerm_virtual_network.this.tags["biv"] == "333"
    error_message = "Virtual network must carry the biv tag."
  }

  assert {
    condition     = azurerm_network_security_group.this["nsg-workload-01"].tags["biv"] == "333"
    error_message = "Network security group must carry the biv tag."
  }
}

run "creates_route_table_and_peering" {
  command = plan

  assert {
    condition     = one(azurerm_route_table.this["rt-workload-01"].route).next_hop_type == "VirtualAppliance"
    error_message = "Route table must include the supplied route."
  }

  assert {
    condition     = azurerm_virtual_network_peering.this["peer-to-hub"].allow_forwarded_traffic == true
    error_message = "Peering must use the supplied forwarded-traffic setting."
  }
}

run "accepts_disconnected_contract" {
  command = plan

  variables {
    route_tables             = {}
    route_table_associations = {}
    peerings                 = {}
  }
}

run "rejects_invalid_biv" {
  command = plan

  variables {
    biv = "907"
  }

  expect_failures = [var.biv]
}
