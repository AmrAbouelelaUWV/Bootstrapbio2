package main

import rego.v1

taggable_resource_types := {
  "azurerm_linux_virtual_machine",
  "azurerm_network_interface",
  "azurerm_virtual_machine_extension",
  "azurerm_windows_virtual_machine",
}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.mode == "managed"
  taggable_resource_types[resource.type]
  not resource.change.after.tags.biv
  msg := sprintf("Resource %s must have a biv tag.", [resource.address])
}
