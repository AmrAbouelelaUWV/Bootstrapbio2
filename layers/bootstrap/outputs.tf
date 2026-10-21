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
  value       = try(one(azurerm_private_endpoint.blob[*].id), null)
}

output "private_dns_zone_id" {
  description = "Private DNS zone ID for the backend storage account blob service."
  value       = try(one(azurerm_private_dns_zone.blob[*].id), null)
}

output "self_hosted_runner_job_name" {
  description = "Self-hosted runner Container Apps Job name."
  value       = try(azurerm_container_app_job.self_hosted_runner[0].name, null)
}

output "self_hosted_runner_job_id" {
  description = "Self-hosted runner Container Apps Job resource ID."
  value       = try(azurerm_container_app_job.self_hosted_runner[0].id, null)
}

output "self_hosted_runner_environment_id" {
  description = "Container Apps environment ID used for the self-hosted runner job."
  value       = try(azurerm_container_app_environment.self_hosted_runner[0].id, null)
}

output "bootstrap_virtual_network_id" {
  description = "Virtual network ID used by the bootstrap runner and private endpoint network."
  value       = try(azurerm_virtual_network.bootstrap[0].id, null)
}

output "cmk_user_assigned_identity_id" {
  description = "User-assigned identity ID used by the state storage account for CMK access."
  value       = local.cmk_identity_id
}

output "cmk_enabled" {
  description = "Indicates whether customer-managed key encryption is enabled for state storage."
  value       = var.cmk_enabled
}
