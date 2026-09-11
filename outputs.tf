output "resource_group_name" {
  description = "Terraform state resource group name."
  value       = azurerm_resource_group.this.name
}

output "storage_account_name" {
  description = "Terraform state storage account name."
  value       = azurerm_storage_account.this.name
}

output "container_name" {
  description = "Terraform state blob container name."
  value       = azurerm_storage_container.tfstate.name
}

output "key_vault_name" {
  description = "Bootstrap Key Vault name."
  value       = azurerm_key_vault.this.name
}

output "key_vault_id" {
  description = "Bootstrap Key Vault resource ID."
  value       = azurerm_key_vault.this.id
}

output "managed_identity_client_id" {
  description = "Client ID for CI/CD OIDC authentication."
  value       = azurerm_user_assigned_identity.terraform.client_id
}

output "managed_identity_principal_id" {
  description = "Principal ID of the Terraform pipeline managed identity."
  value       = azurerm_user_assigned_identity.terraform.principal_id
}

output "tenant_id" {
  description = "Azure tenant ID for CI/CD OIDC authentication."
  value       = local.tenant_id
}

output "subscription_id" {
  description = "Azure subscription ID."
  value       = local.subscription_id
}

output "backend_config" {
  description = "Backend values for downstream Terraform roots."
  value = {
    resource_group_name  = azurerm_resource_group.this.name
    storage_account_name = azurerm_storage_account.this.name
    container_name       = azurerm_storage_container.tfstate.name
    use_azuread_auth     = true
  }
}
