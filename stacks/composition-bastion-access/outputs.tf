output "resource_group_name" {
  description = "Bastion access resource group name."
  value       = azurerm_resource_group.this.name
}

output "network_id" {
  description = "Dedicated Bastion VNet ID."
  value       = module.network.id
}

output "bastion_subnet_id" {
  description = "AzureBastionSubnet ID."
  value       = module.network.subnet_ids["AzureBastionSubnet"]
}

output "bastion_id" {
  description = "Azure Bastion host ID."
  value       = azurerm_bastion_host.this.id
}

output "bastion_name" {
  description = "Azure Bastion host name."
  value       = azurerm_bastion_host.this.name
}

output "public_ip_id" {
  description = "Bastion public IP ID."
  value       = azurerm_public_ip.this.id
}
