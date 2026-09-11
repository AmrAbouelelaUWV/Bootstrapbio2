output "id" {
  description = "Virtual network ID."
  value       = azurerm_virtual_network.this.id
}

output "name" {
  description = "Virtual network name."
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Subnet IDs keyed by subnet name."
  value       = { for name, subnet in azurerm_subnet.this : name => subnet.id }
}

output "subnet_names" {
  description = "Subnet names keyed by subnet name."
  value       = { for name, subnet in azurerm_subnet.this : name => subnet.name }
}

output "network_security_group_ids" {
  description = "Network security group IDs keyed by NSG name."
  value       = { for name, nsg in azurerm_network_security_group.this : name => nsg.id }
}

output "private_dns_zone_ids" {
  description = "Private DNS zone IDs keyed by zone name."
  value       = { for name, zone in azurerm_private_dns_zone.this : name => zone.id }
}

output "route_table_ids" {
  description = "Route table IDs keyed by route table name."
  value       = { for name, route_table in azurerm_route_table.this : name => route_table.id }
}

output "peering_ids" {
  description = "Virtual network peering IDs keyed by peering name."
  value       = { for name, peering in azurerm_virtual_network_peering.this : name => peering.id }
}
