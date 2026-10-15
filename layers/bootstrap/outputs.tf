output "resource_group_name" {
  description = "Bootstrap resource group name."
  value       = azurerm_resource_group.tfstate.name
}

output "storage_account_name" {
  description = "Bootstrap storage account name."
  value       = azurerm_storage_account.tfstate.name
}

output "storage_account_id" {
  description = "Bootstrap storage account ID."
  value       = azurerm_storage_account.tfstate.id
}

output "container_name" {
  description = "Bootstrap storage container name."
  value       = azurerm_storage_container.tfstate.name
}
