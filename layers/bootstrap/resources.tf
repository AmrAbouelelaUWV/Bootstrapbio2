locals {
  private_dns_zone_resource_group_name = coalesce(var.private_dns_zone_resource_group_name, azurerm_resource_group.tfstate.name)
}

resource "azurerm_resource_group" "tfstate" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags

  lifecycle {
    prevent_destroy = true
  }
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
  shared_access_key_enabled       = true
  tags                            = var.tags

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

  dynamic "network_rules" {
    for_each = var.network_rules_enabled ? [1] : []
    content {
      default_action             = "Deny"
      bypass                     = var.network_bypass
      ip_rules                   = var.allowed_ip_rules
      virtual_network_subnet_ids = var.allowed_subnet_ids
    }
  }

  lifecycle {
    prevent_destroy = true

    precondition {
      condition     = !var.private_endpoint_enabled || (var.private_endpoint_subnet_id != null && var.private_dns_zone_virtual_network_id != null)
      error_message = "private_endpoint_subnet_id and private_dns_zone_virtual_network_id are required when private_endpoint_enabled is true."
    }

    precondition {
      condition     = var.public_network_access_enabled || var.private_endpoint_enabled
      error_message = "Do not disable public network access unless a private endpoint is enabled for the backend storage account."
    }

    precondition {
      condition     = !var.network_rules_enabled || var.public_network_access_enabled
      error_message = "network_rules_enabled only applies when public network access remains enabled. Disable public access only after migrating Terraform execution to private connectivity."
    }
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_private_dns_zone" "blob" {
  count               = var.private_endpoint_enabled ? 1 : 0
  name                = var.private_dns_zone_name
  resource_group_name = local.private_dns_zone_resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  count                 = var.private_endpoint_enabled ? 1 : 0
  name                  = "${var.storage_account_name}-blob-link"
  private_dns_zone_id   = azurerm_private_dns_zone.blob[0].id
  virtual_network_id    = var.private_dns_zone_virtual_network_id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_endpoint" "blob" {
  count               = var.private_endpoint_enabled ? 1 : 0
  name                = "${var.storage_account_name}-blob-pe"
  location            = azurerm_resource_group.tfstate.location
  resource_group_name = azurerm_resource_group.tfstate.name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${var.storage_account_name}-blob-psc"
    private_connection_resource_id = azurerm_storage_account.tfstate.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "blob-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob[0].id]
  }

  lifecycle {
    prevent_destroy = true
  }
}
