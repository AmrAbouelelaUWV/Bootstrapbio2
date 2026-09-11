package main

import rego.v1

taggable_resource_types := {
  "azurerm_network_security_group",
  "azurerm_route_table",
  "azurerm_virtual_network",
  "azurerm_virtual_network_peering",
}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.mode == "managed"
  taggable_resource_types[resource.type]
  not resource.change.after.tags.biv
  msg := sprintf("Resource %s must have a biv tag.", [resource.address])
}
