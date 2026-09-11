mock_provider "azurerm" {}

variables {
  workload                                   = "management"
  environment                                = "dev"
  location                                   = "westeurope"
  region_code                                = "we"
  instance                                   = "01"
  biv                                        = "233"
  address_space                              = ["10.90.0.0/24"]
  bastion_subnet_prefix                      = "10.90.0.0/26"
  target_virtual_network_id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-management-dev-we-01/providers/Microsoft.Network/virtualNetworks/vnet-management-dev-we-01"
  target_virtual_network_name                = "vnet-management-dev-we-01"
  target_virtual_network_resource_group_name = "rg-management-dev-we-01"
}

run "accepts_valid_stack_contract" {
  command = plan
}

run "applies_company_naming" {
  command = plan

  assert {
    condition     = azurerm_resource_group.this.name == "rg-bas-management-dev-we-01"
    error_message = "Resource group name must follow company naming."
  }

  assert {
    condition     = azurerm_bastion_host.this.name == "bas-management-dev-we-01"
    error_message = "Bastion name must follow company naming."
  }
}

run "creates_dedicated_bastion_network" {
  command = plan

  assert {
    condition     = module.network.name == "vnet-bas-management-dev-we-01"
    error_message = "Bastion access stack must create a dedicated Bastion VNet."
  }

  assert {
    condition     = contains(keys(module.network.subnet_ids), "AzureBastionSubnet")
    error_message = "Bastion access stack must create AzureBastionSubnet."
  }
}

run "creates_reverse_peering" {
  command = plan

  assert {
    condition     = azurerm_virtual_network_peering.target_to_bastion.name == "peer-target-to-bastion"
    error_message = "Target VNet must be peered back to the Bastion VNet."
  }
}

run "applies_biv_tags" {
  command = plan

  assert {
    condition     = azurerm_bastion_host.this.tags["biv"] == "233"
    error_message = "Bastion host must carry the biv tag."
  }
}

run "rejects_invalid_biv" {
  command = plan

  variables {
    biv = "907"
  }

  expect_failures = [var.biv]
}
