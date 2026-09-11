mock_provider "azurerm" {}

variables {
  workload          = "tfstate"
  environment       = "dev"
  location          = "westeurope"
  region_code       = "we"
  instance          = "01"
  biv               = "233"
  tenant_id         = "11111111-1111-1111-1111-111111111111"
  subscription_id   = "00000000-0000-0000-0000-000000000000"
  github_owner      = "xx"
  github_repository = "platform-workloads"
}

run "accepts_valid_bootstrap_contract" {
  command = plan
}

run "applies_company_naming" {
  command = plan

  assert {
    condition     = azurerm_resource_group.this.name == "rg-tfstate-dev-we-01"
    error_message = "Resource group name must follow company naming."
  }

  assert {
    condition     = azurerm_storage_account.this.name == "satfstatedevwe01"
    error_message = "Storage account name must follow Azure-safe company naming."
  }

  assert {
    condition     = azurerm_user_assigned_identity.terraform.name == "mi-tfstate-dev-we-01"
    error_message = "Managed identity name must follow company naming."
  }

  assert {
    condition     = azurerm_key_vault.this.name == "kv-tfstate-dev-we-01"
    error_message = "Key Vault name must follow company naming."
  }
}

run "creates_secure_state_storage" {
  command = plan

  assert {
    condition     = azurerm_storage_account.this.shared_access_key_enabled == false
    error_message = "State storage must use Azure AD auth, not shared keys."
  }

  assert {
    condition     = azurerm_storage_account.this.default_to_oauth_authentication == true
    error_message = "State storage must default to Azure AD authentication."
  }

  assert {
    condition     = azurerm_storage_account.this.local_user_enabled == false
    error_message = "State storage local users must be disabled."
  }

  assert {
    condition     = azurerm_storage_account.this.allow_nested_items_to_be_public == false
    error_message = "State storage must not allow public nested items."
  }

  assert {
    condition     = azurerm_storage_container.tfstate.container_access_type == "private"
    error_message = "State container must be private."
  }
}

run "creates_github_oidc_identity" {
  command = plan

  assert {
    condition     = azurerm_federated_identity_credential.github.subject == "repo:xx/platform-workloads:environment:dev"
    error_message = "Federated credential must be scoped to the expected GitHub environment."
  }
}

run "creates_secure_bootstrap_key_vault" {
  command = plan

  assert {
    condition     = azurerm_key_vault.this.rbac_authorization_enabled == true
    error_message = "Bootstrap Key Vault must use Azure RBAC authorization."
  }

  assert {
    condition     = azurerm_key_vault.this.purge_protection_enabled == true
    error_message = "Bootstrap Key Vault must enable purge protection."
  }

  assert {
    condition     = azurerm_key_vault.this.soft_delete_retention_days == 90
    error_message = "Bootstrap Key Vault must keep deleted items for 90 days."
  }

  assert {
    condition     = azurerm_key_vault.this.network_acls[0].default_action == "Deny"
    error_message = "Bootstrap Key Vault firewall must deny public callers by default."
  }
}

run "rejects_invalid_biv" {
  command = plan

  variables {
    biv = "907"
  }

  expect_failures = [var.biv]
}
