package main

import rego.v1

taggable_resource_types := {
  "azurerm_pim_eligible_role_assignment",
  "azurerm_resource_group",
  "azurerm_role_assignment",
}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.mode == "managed"
  taggable_resource_types[resource.type]
  not resource.change.after.tags.biv
  msg := sprintf("Resource %s must have a biv tag.", [resource.address])
}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "azurerm_network_interface"
  ip_configuration := resource.change.after.ip_configuration[_]
  ip_configuration.public_ip_address_id != null
  msg := sprintf("Management stack NIC %s must not attach a public IP.", [resource.address])
}
