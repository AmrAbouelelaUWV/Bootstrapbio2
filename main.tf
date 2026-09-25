data "azurerm_client_config" "current" {}

locals {
  suffix               = "${var.workload}-${var.environment}-${var.region_code}-${var.instance}"
  compact_suffix       = "${replace(var.workload, "-", "")}${var.environment}${var.region_code}${var.instance}${var.storage_account_unique_suffix}"
  tags                 = merge(var.tags, { biv = var.biv })
  tenant_id            = coalesce(var.tenant_id, data.azurerm_client_config.current.tenant_id)
  subscription_id      = coalesce(var.subscription_id, data.azurerm_client_config.current.subscription_id)
  subscription_scope   = "/subscriptions/${local.subscription_id}"
  resource_group_name  = "rg-${local.suffix}"
  storage_account_name = "sa${local.compact_suffix}"
  key_vault_name       = var.key_vault_unique_suffix == "" ? "kv-${local.suffix}" : "kv-${local.suffix}-${var.key_vault_unique_suffix}"
  container_name       = "${var.workload}-${var.environment}"
  identity_name        = "mi-${local.suffix}"
  credential_name      = "fc-github-${var.environment}"
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.tags
}

resource "azurerm_storage_account" "this" {
  # checkov:skip=CKV_AZURE_43:Name is generated from validated CAF components and tested with terraform test.
  # checkov:skip=CKV_AZURE_33:Queue logging is configured with azurerm_storage_account_queue_properties.
  name                             = local.storage_account_name
  resource_group_name              = azurerm_resource_group.this.name
  location                         = azurerm_resource_group.this.location
  account_tier                     = "Standard"
  account_replication_type         = var.replication_type
  account_kind                     = "StorageV2"
  min_tls_version                  = "TLS1_2"
  shared_access_key_enabled        = false
  default_to_oauth_authentication  = true
  local_user_enabled               = false
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false
  public_network_access_enabled    = true
  tags                             = local.tags

  blob_properties {
    versioning_enabled  = true
    change_feed_enabled = true

    delete_retention_policy {
      days = var.blob_delete_retention_days
    }

    container_delete_retention_policy {
      days = var.container_delete_retention_days
    }
  }

}

resource "azurerm_storage_account_queue_properties" "this" {
  storage_account_id = azurerm_storage_account.this.id

  logging {
    delete                = true
    read                  = true
    version               = "1.0"
    write                 = true
    retention_policy_days = 30
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = local.container_name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

resource "azurerm_key_vault" "this" {
  # checkov:skip=CKV_AZURE_189:Bootstrap runs before private networking exists; the vault firewall denies public callers by default.
  name                          = local.key_vault_name
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  tenant_id                     = local.tenant_id
  sku_name                      = "standard"
  rbac_authorization_enabled    = true
  purge_protection_enabled      = true
  soft_delete_retention_days    = var.key_vault_soft_delete_retention_days
  public_network_access_enabled = true
  tags                          = local.tags

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }
}

resource "azurerm_user_assigned_identity" "terraform" {
  name                = local.identity_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = local.tags
}

resource "azurerm_federated_identity_credential" "github" {
  name                      = local.credential_name
  user_assigned_identity_id = azurerm_user_assigned_identity.terraform.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = "https://token.actions.githubusercontent.com"
  subject                   = "repo:${var.github_owner}/${var.github_repository}:environment:${var.environment}"
}

resource "azurerm_role_assignment" "terraform_contributor" {
  count = var.create_role_assignments && var.assign_subscription_contributor ? 1 : 0

  scope                = local.subscription_scope
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.terraform.principal_id
}

resource "azurerm_role_assignment" "terraform_contributor_rg" {
  count = var.create_role_assignments && !var.assign_subscription_contributor ? 1 : 0

  scope                = azurerm_resource_group.this.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.terraform.principal_id
}

resource "azurerm_role_assignment" "state_blob_data_contributor" {
  count = var.create_role_assignments ? 1 : 0

  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.terraform.principal_id
}

resource "azurerm_role_assignment" "key_vault_administrator" {
  count = var.create_role_assignments ? 1 : 0

  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_user_assigned_identity.terraform.principal_id
}
