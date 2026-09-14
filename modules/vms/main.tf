locals {
  linux_vms = {
    for name, vm in var.vms : name => vm
    if vm.os_type == "linux"
  }

  windows_vms = {
    for name, vm in var.vms : name => vm
    if vm.os_type == "windows"
  }

  windows_computer_names = {
    for name, vm in local.windows_vms :
    name => substr(regexreplace(vm.name, "[^0-9A-Za-z-]", ""), 0, 15)
  }
}

resource "azurerm_network_interface" "this" {
  for_each = var.vms

  name                = each.value.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  for_each = local.linux_vms

  name                            = each.value.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = each.value.size
  admin_username                  = each.value.admin_username
  network_interface_ids           = [azurerm_network_interface.this[each.key].id]
  encryption_at_host_enabled      = true
  disable_password_authentication = true
  source_image_id                 = each.value.source_image_id
  tags                            = local.tags

  admin_ssh_key {
    username   = each.value.admin_username
    public_key = each.value.admin_ssh_public_key
  }

  os_disk {
    caching              = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
  }

  dynamic "source_image_reference" {
    for_each = each.value.source_image_id == null && each.value.source_image_reference != null ? [each.value.source_image_reference] : []

    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  identity {
    type = "SystemAssigned"
  }

  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_account_uri
  }

}

resource "azurerm_windows_virtual_machine" "this" {
  for_each = local.windows_vms

  name                       = each.value.name
  computer_name              = local.windows_computer_names[each.key]
  location                   = var.location
  resource_group_name        = var.resource_group_name
  size                       = each.value.size
  admin_username             = each.value.admin_username
  admin_password             = lookup(var.admin_passwords, each.key, null)
  network_interface_ids      = [azurerm_network_interface.this[each.key].id]
  encryption_at_host_enabled = true
  source_image_id            = each.value.source_image_id
  tags                       = local.tags

  os_disk {
    caching              = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type
  }

  dynamic "source_image_reference" {
    for_each = each.value.source_image_id == null && each.value.source_image_reference != null ? [each.value.source_image_reference] : []

    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  dynamic "plan" {
    for_each = each.value.plan != null ? [each.value.plan] : []

    content {
      name      = plan.value.name
      product   = plan.value.product
      publisher = plan.value.publisher
    }
  }

  identity {
    type = "SystemAssigned"
  }

  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_account_uri
  }

  lifecycle {
    precondition {
      condition     = contains(keys(var.admin_passwords), each.key)
      error_message = "Each Windows VM must have a matching entry in var.admin_passwords."
    }
  }
}

resource "azurerm_virtual_machine_extension" "entra_login_linux" {
  for_each = local.linux_vms

  name                 = "AADSSHLoginForLinux"
  virtual_machine_id   = azurerm_linux_virtual_machine.this[each.key].id
  publisher            = "Microsoft.Azure.ActiveDirectory"
  type                 = "AADSSHLoginForLinux"
  type_handler_version = "1.0"
  tags                 = local.tags
}

resource "azurerm_virtual_machine_extension" "entra_login_windows" {
  for_each = local.windows_vms

  name                 = "AADLoginForWindows"
  virtual_machine_id   = azurerm_windows_virtual_machine.this[each.key].id
  publisher            = "Microsoft.Azure.ActiveDirectory"
  type                 = "AADLoginForWindows"
  type_handler_version = "2.0"
  tags                 = local.tags
}
