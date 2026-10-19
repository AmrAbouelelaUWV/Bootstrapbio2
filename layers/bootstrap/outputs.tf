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

output "private_endpoint_id" {
  description = "Private endpoint ID for the backend storage account blob service."
  value       = one(azurerm_private_endpoint.blob[*].id)
}

output "private_dns_zone_id" {
  description = "Private DNS zone ID for the backend storage account blob service."
  value       = one(azurerm_private_dns_zone.blob[*].id)
}
