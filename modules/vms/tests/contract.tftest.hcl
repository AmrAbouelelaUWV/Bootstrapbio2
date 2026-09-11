mock_provider "azurerm" {}

variables {
  resource_group_name = "rg-management-dev-we-01"
  location            = "westeurope"
  biv                 = "233"

  admin_passwords = {
    windows = "ThisIsATestPasswordOnly!12345"
  }

  vms = {
    linux = {
      name                 = "vm-linux-management-dev-we-01"
      nic_name             = "nic-linux-management-dev-we-01"
      os_type              = "linux"
      subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-management-dev-we-01/providers/Microsoft.Network/virtualNetworks/vnet-management-dev-we-01/subnets/snet-management-dev-we-01"
      admin_username       = "azureadmin"
      admin_ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICGzuh42P3pqaJnBpgoScqxSH+6izTl4lXBvoCLrGGpI tftest-fixture"
      source_image_reference = {
        publisher = "Canonical"
        offer     = "ubuntu-24_04-lts"
        sku       = "server"
        version   = "latest"
      }
    }

    windows = {
      name           = "vm-windows-management-dev-we-01"
      nic_name       = "nic-windows-management-dev-we-01"
      os_type        = "windows"
      subnet_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-management-dev-we-01/providers/Microsoft.Network/virtualNetworks/vnet-management-dev-we-01/subnets/snet-management-dev-we-01"
      admin_username = "zauadmin"
      source_image_reference = {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2022-datacenter-azure-edition"
        version   = "latest"
      }
    }
  }
}

run "accepts_valid_contract" {
  command = plan
}

run "creates_private_nics" {
  command = plan

  assert {
    condition     = azurerm_network_interface.this["linux"].name == "nic-linux-management-dev-we-01"
    error_message = "Linux NIC name must come from the VM object."
  }

  assert {
    condition     = azurerm_network_interface.this["windows"].name == "nic-windows-management-dev-we-01"
    error_message = "Windows NIC name must come from the VM object."
  }
}

run "applies_hardening_baseline" {
  command = plan

  assert {
    condition     = azurerm_linux_virtual_machine.this["linux"].disable_password_authentication == true
    error_message = "Linux password authentication must stay disabled."
  }

  assert {
    condition     = azurerm_linux_virtual_machine.this["linux"].encryption_at_host_enabled == true
    error_message = "Linux VM must enable encryption at host."
  }

  assert {
    condition     = azurerm_windows_virtual_machine.this["windows"].encryption_at_host_enabled == true
    error_message = "Windows VM must enable encryption at host."
  }
}

run "applies_biv_tag" {
  command = plan

  assert {
    condition     = azurerm_linux_virtual_machine.this["linux"].tags["biv"] == "233"
    error_message = "Linux VM must carry the biv tag."
  }

  assert {
    condition     = azurerm_windows_virtual_machine.this["windows"].tags["biv"] == "233"
    error_message = "Windows VM must carry the biv tag."
  }
}

run "creates_entra_login_extensions" {
  command = plan

  assert {
    condition     = azurerm_virtual_machine_extension.entra_login_linux["linux"].type == "AADSSHLoginForLinux"
    error_message = "Linux VM must have the Entra SSH login extension."
  }

  assert {
    condition     = azurerm_virtual_machine_extension.entra_login_windows["windows"].type == "AADLoginForWindows"
    error_message = "Windows VM must have the Entra login extension."
  }
}

run "rejects_invalid_biv" {
  command = plan

  variables {
    biv = "907"
  }

  expect_failures = [var.biv]
}

run "rejects_invalid_os_type" {
  command = plan

  variables {
    vms = {
      bad = {
        name            = "vm-bad-management-dev-we-01"
        nic_name        = "nic-bad-management-dev-we-01"
        os_type         = "solaris"
        subnet_id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-management-dev-we-01/providers/Microsoft.Network/virtualNetworks/vnet-management-dev-we-01/subnets/snet-management-dev-we-01"
        source_image_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-images-dev-we-01/providers/Microsoft.Compute/galleries/gallery/images/image/versions/1.0.0"
      }
    }
  }

  expect_failures = [var.vms]
}
