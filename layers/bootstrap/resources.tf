resource "azurerm_resource_group" "tfstate" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

locals {
  cmk_identity_id    = var.cmk_user_assigned_identity_id != null ? var.cmk_user_assigned_identity_id : try(azurerm_user_assigned_identity.cmk[0].id, null)
  cmk_key_vault_name = var.cmk_key_vault_id == null ? null : element(reverse(split("/", trim(var.cmk_key_vault_id, "/"))), 0)
  cmk_key_vault_uri  = var.cmk_key_vault_id == null ? null : (startswith(var.cmk_key_vault_id, "https://") ? trim(var.cmk_key_vault_id, "/") : "https://${local.cmk_key_vault_name}.vault.azure.net")
  cmk_key_vault_key_id = var.cmk_key_name == null || local.cmk_key_vault_uri == null ? null : (
    var.cmk_key_version == null || var.cmk_key_version == "" ? "${local.cmk_key_vault_uri}/keys/${var.cmk_key_name}" : "${local.cmk_key_vault_uri}/keys/${var.cmk_key_name}/${var.cmk_key_version}"
  )
}

resource "azurerm_user_assigned_identity" "cmk" {
  count = var.cmk_enabled && var.cmk_user_assigned_identity_id == null ? 1 : 0

  name                = var.cmk_user_assigned_identity_name
  location            = azurerm_resource_group.tfstate.location
  resource_group_name = azurerm_resource_group.tfstate.name
  tags                = var.tags
}

resource "azurerm_storage_account" "tfstate" {
  name                            = var.storage_account_name
  resource_group_name             = azurerm_resource_group.tfstate.name
  location                        = azurerm_resource_group.tfstate.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  min_tls_version                 = "TLS1_2"
  public_network_access           = var.public_network_access_enabled ? "Enabled" : "Disabled"
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled       = var.blob_versioning_enabled
    change_feed_enabled      = var.change_feed_enabled
    last_access_time_enabled = var.last_access_time_enabled

    delete_retention_policy {
      days = var.blob_delete_retention_days
    }

    container_delete_retention_policy {
      days = var.container_delete_retention_days
    }
  }

  dynamic "identity" {
    for_each = var.cmk_enabled ? [1] : []
    content {
      type         = "UserAssigned"
      identity_ids = [local.cmk_identity_id]
    }
  }

  tags = var.tags

  lifecycle {
    prevent_destroy = true

    precondition {
      condition     = !var.cmk_enabled || local.cmk_key_vault_key_id != null
      error_message = "cmk_key_vault_id and cmk_key_name are required when cmk_enabled is true."
    }

    precondition {
      condition     = !var.cmk_enabled || local.cmk_identity_id != null
      error_message = "A user-assigned identity is required for CMK. Provide cmk_user_assigned_identity_id or allow this module to create one."
    }
  }
}

resource "azurerm_storage_account_customer_managed_key" "tfstate" {
  count = var.cmk_enabled ? 1 : 0

  storage_account_id        = azurerm_storage_account.tfstate.id
  key_vault_key_id          = local.cmk_key_vault_key_id
  user_assigned_identity_id = local.cmk_identity_id

  depends_on = [
    azurerm_role_assignment.cmk_storage_encryption_user
  ]
}

resource "azurerm_role_assignment" "cmk_storage_encryption_user" {
  count = var.cmk_enabled && var.cmk_user_assigned_identity_id == null ? 1 : 0

  scope                = var.cmk_key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_user_assigned_identity.cmk[0].principal_id
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

locals {
  storage_allowed_subnet_ids = var.network_rules_enabled ? distinct(concat(
    var.allowed_subnet_ids,
    var.self_hosted_runner_enabled ? [azurerm_subnet.self_hosted_runner[0].id] : []
  )) : []
}

resource "azurerm_storage_account_network_rules" "tfstate" {
  count = var.network_rules_enabled ? 1 : 0

  storage_account_id         = azurerm_storage_account.tfstate.id
  default_action             = "Deny"
  bypass                     = var.network_bypass
  ip_rules                   = var.allowed_ip_rules
  virtual_network_subnet_ids = local.storage_allowed_subnet_ids
}

resource "azurerm_private_dns_zone" "blob" {
  count = var.private_endpoint_enabled ? 1 : 0

  name                = var.private_dns_zone_name
  resource_group_name = local.private_dns_zone_resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  count = var.private_endpoint_enabled ? 1 : 0

  name                 = "${azurerm_storage_account.tfstate.name}-blob-link"
  private_dns_zone_id  = azurerm_private_dns_zone.blob[0].id
  virtual_network_id   = local.private_dns_zone_virtual_network_id
  registration_enabled = false

  lifecycle {
    precondition {
      condition     = local.private_dns_zone_virtual_network_id != null
      error_message = "private_dns_zone_virtual_network_id is required when private_endpoint_enabled is true, unless the bootstrap VNet is created by this module."
    }
  }
}

resource "azurerm_private_endpoint" "blob" {
  count = var.private_endpoint_enabled ? 1 : 0

  name                = "${azurerm_storage_account.tfstate.name}-blob-pe"
  location            = azurerm_resource_group.tfstate.location
  resource_group_name = azurerm_resource_group.tfstate.name
  subnet_id           = local.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${azurerm_storage_account.tfstate.name}-blob-psc"
    private_connection_resource_id = azurerm_storage_account.tfstate.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "blob"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob[0].id]
  }

  lifecycle {
    precondition {
      condition     = local.private_endpoint_subnet_id != null
      error_message = "private_endpoint_subnet_id is required when private_endpoint_enabled is true, unless the bootstrap subnet is created by this module."
    }
  }
}
