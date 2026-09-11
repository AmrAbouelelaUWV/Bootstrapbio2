package main

taggable_resource_types := {
  "azurerm_key_vault",
  "azurerm_resource_group",
  "azurerm_storage_account",
  "azurerm_user_assigned_identity",
}

deny contains msg if {
  some i
  resource := input.resource_changes[i]
  resource.mode == "managed"
  taggable_resource_types[resource.type]
  not resource.change.after.tags.biv
  msg := sprintf("Resource %s must have a biv tag.", [resource.address])
}

deny contains msg if {
  some i
  resource := input.resource_changes[i]
  resource.type == "azurerm_storage_account"
  resource.change.after.shared_access_key_enabled != false
  msg := sprintf("State storage account %s must disable shared access keys.", [resource.address])
}

deny contains msg if {
  some i
  resource := input.resource_changes[i]
  resource.type == "azurerm_storage_container"
  resource.change.after.container_access_type != "private"
  msg := sprintf("State container %s must be private.", [resource.address])
}

deny contains msg if {
  some i
  resource := input.resource_changes[i]
  resource.type == "azurerm_key_vault"
  resource.change.after.rbac_authorization_enabled != true
  msg := sprintf("Key Vault %s must use Azure RBAC authorization.", [resource.address])
}

deny contains msg if {
  some i
  resource := input.resource_changes[i]
  resource.type == "azurerm_key_vault"
  resource.change.after.purge_protection_enabled != true
  msg := sprintf("Key Vault %s must enable purge protection.", [resource.address])
}
