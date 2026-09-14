output "resource_group_name" {
  description = "Resource group name."
  value       = azurerm_resource_group.this.name
}

output "network_id" {
  description = "Jumphost virtual network ID."
  value       = module.network.id
}

output "subnet_ids" {
  description = "Subnet IDs keyed by subnet name."
  value       = module.network.subnet_ids
}

output "bastion_id" {
  description = "Azure Bastion host ID."
  value       = module.bastion_access.bastion_id
}

output "bastion_name" {
  description = "Azure Bastion host name."
  value       = module.bastion_access.bastion_name
}

output "bastion_public_ip_id" {
  description = "Bastion public IP resource ID."
  value       = module.bastion_access.public_ip_id
}

output "vm_ids" {
  description = "Management VM IDs keyed by logical name."
  value       = module.vms.vm_ids
}

output "vm_private_ip_addresses" {
  description = "Management VM private IP addresses keyed by logical name."
  value       = module.vms.private_ip_addresses
}

output "linux_bastion_ssh_command" {
  description = "Azure CLI command for SSH to the Linux VM through Bastion."
  value       = var.enable_linux_vm ? "az network bastion ssh --name ${module.bastion_access.bastion_name} --resource-group ${module.bastion_access.resource_group_name} --target-resource-id ${module.vms.vm_ids["linux"]} --auth-type AAD" : null
}
