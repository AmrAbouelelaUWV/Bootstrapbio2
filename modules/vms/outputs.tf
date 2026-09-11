output "vm_ids" {
  description = "Virtual machine IDs keyed by logical name."
  value = merge(
    { for name, vm in azurerm_linux_virtual_machine.this : name => vm.id },
    { for name, vm in azurerm_windows_virtual_machine.this : name => vm.id }
  )
}

output "vm_names" {
  description = "Virtual machine names keyed by logical name."
  value = merge(
    { for name, vm in azurerm_linux_virtual_machine.this : name => vm.name },
    { for name, vm in azurerm_windows_virtual_machine.this : name => vm.name }
  )
}

output "network_interface_ids" {
  description = "Network interface IDs keyed by logical name."
  value       = { for name, nic in azurerm_network_interface.this : name => nic.id }
}

output "private_ip_addresses" {
  description = "Private IP addresses keyed by logical name."
  value       = { for name, nic in azurerm_network_interface.this : name => nic.private_ip_address }
}

output "principal_ids" {
  description = "System-assigned managed identity principal IDs keyed by logical name."
  value = merge(
    { for name, vm in azurerm_linux_virtual_machine.this : name => vm.identity[0].principal_id },
    { for name, vm in azurerm_windows_virtual_machine.this : name => vm.identity[0].principal_id }
  )
}
