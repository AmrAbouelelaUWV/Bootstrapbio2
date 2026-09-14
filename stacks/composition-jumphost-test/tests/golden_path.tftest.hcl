mock_provider "azurerm" {}

variables {
  workload                 = "management"
  environment              = "dev"
  location                 = "westeurope"
  region_code              = "we"
  instance                 = "01"
  biv                      = "233"
  address_space            = ["10.10.0.0/16"]
  management_subnet_prefix = "10.10.1.0/24"
  bastion_address_space    = ["10.90.0.0/24"]
  bastion_subnet_prefix    = "10.90.0.0/26"

  linux_vm = {
    admin_username       = "azureadmin"
    admin_ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICGzuh42P3pqaJnBpgoScqxSH+6izTl4lXBvoCLrGGpI tftest-fixture"
  }

  windows_vm = {
    admin_username = "zauadmin"
  }

  admin_passwords = {
    windows = "ThisIsATestPasswordOnly!12345"
  }

  admin_login_principal_ids = {
    platform-admins = "00000000-0000-0000-0000-000000000001"
  }

  user_login_principal_ids = {
    platform-readers = "00000000-0000-0000-0000-000000000002"
  }

  enable_pim_eligible_role_assignments = true
}

run "accepts_valid_stack_contract" {
  command = plan
}

run "applies_company_naming" {
  command = plan

  assert {
    condition     = azurerm_resource_group.this.name == "rg-management-dev-we-01"
    error_message = "Resource group name must follow company naming."
  }

  assert {
    condition     = module.bastion_access.bastion_name == "bas-management-dev-we-01"
    error_message = "Bastion name must follow company naming."
  }
}

run "keeps_bastion_in_dedicated_access_stack" {
  command = plan

  assert {
    condition     = !contains(keys(module.network.subnet_ids), "AzureBastionSubnet")
    error_message = "Jumphost workload network must not contain AzureBastionSubnet."
  }

  assert {
    condition     = module.bastion_access.bastion_name == "bas-management-dev-we-01"
    error_message = "Bastion access must use a dedicated VNet."
  }
}

run "applies_biv_tags" {
  command = plan

  assert {
    condition     = azurerm_resource_group.this.tags["biv"] == "233"
    error_message = "Resource group must carry the biv tag."
  }

  assert {
    condition     = module.bastion_access.bastion_name == "bas-management-dev-we-01"
    error_message = "Bastion access stack must receive the same naming context."
  }
}

run "creates_pim_assignments" {
  command = plan

  assert {
    condition     = length(azurerm_pim_eligible_role_assignment.vm_admin_login) == 2
    error_message = "PIM admin login assignment must be created for each enabled VM."
  }

  assert {
    condition     = length(azurerm_pim_eligible_role_assignment.vm_user_login) == 2
    error_message = "PIM user login assignment must be created for each enabled VM."
  }
}

run "rejects_invalid_biv" {
  command = plan

  variables {
    biv = "907"
  }

  expect_failures = [var.biv]
}
