locals {
  suffix = "${var.workload}-${var.environment}-${var.region_code}-${var.instance}"
  tags   = merge(var.tags, { biv = var.biv })

  resource_group_name = "rg-${local.suffix}"
  network_name        = "vnet-${local.suffix}"
  management_subnet   = "snet-management-${local.suffix}"
  management_nsg      = "nsg-management-${local.suffix}"
  linux_vm_name       = "vm-linux-${local.suffix}"
  linux_nic_name      = "nic-linux-${local.suffix}"
  windows_vm_name     = "vm-windows-${local.suffix}"
  windows_nic_name    = "nic-windows-${local.suffix}"

  enabled_vm_keys = concat(
    var.enable_linux_vm ? ["linux"] : [],
    var.enable_windows_vm ? ["windows"] : []
  )

  vm_admin_login_assignments = {
    for pair in setproduct(local.enabled_vm_keys, keys(var.admin_login_principal_ids)) :
    "${pair[0]}-${pair[1]}" => {
      vm_key       = pair[0]
      principal_id = var.admin_login_principal_ids[pair[1]]
    }
  }

  vm_user_login_assignments = {
    for pair in setproduct(local.enabled_vm_keys, keys(var.user_login_principal_ids)) :
    "${pair[0]}-${pair[1]}" => {
      vm_key       = pair[0]
      principal_id = var.user_login_principal_ids[pair[1]]
    }
  }

  vm_reader_assignments = merge(local.vm_admin_login_assignments, local.vm_user_login_assignments)
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.tags
}

module "network" {
  source = "git::https://github.com/nluwv/AZLABS-cnc-azurerm-network.git?ref=main"

  name                = local.network_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = var.address_space
  biv                 = var.biv
  tags                = var.tags

  subnets = {
    (local.management_subnet) = {
      address_prefixes = [var.management_subnet_prefix]
    }
  }

  network_security_groups = {
    (local.management_nsg) = {
      subnet_name = local.management_subnet
      security_rules = {
        AllowSshFromBastion = {
          priority                     = 100
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_ranges           = ["*"]
          destination_port_ranges      = ["22"]
          source_address_prefixes      = [var.bastion_subnet_prefix]
          destination_address_prefixes = ["*"]
        }

        AllowRdpFromBastion = {
          priority                     = 110
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_ranges           = ["*"]
          destination_port_ranges      = ["3389"]
          source_address_prefixes      = [var.bastion_subnet_prefix]
          destination_address_prefixes = ["*"]
        }

        AllowHttpsOutbound = {
          priority                     = 100
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_ranges           = ["*"]
          destination_port_ranges      = ["443"]
          source_address_prefixes      = ["*"]
          destination_address_prefixes = ["Internet"]
        }
      }
    }
  }
}

module "bastion_access" {
  source = "git::https://github.com/nluwv/AZLABS-cnc-azurerm-composition-bastion-access.git?ref=main"

  workload                                   = var.workload
  environment                                = var.environment
  location                                   = var.location
  region_code                                = var.region_code
  instance                                   = var.instance
  biv                                        = var.biv
  tags                                       = var.tags
  address_space                              = var.bastion_address_space
  bastion_subnet_prefix                      = var.bastion_subnet_prefix
  target_virtual_network_id                  = module.network.id
  target_virtual_network_name                = module.network.name
  target_virtual_network_resource_group_name = azurerm_resource_group.this.name
  bastion_sku                                = var.bastion_sku
  availability_zones                         = var.availability_zones
  log_analytics_workspace_id                 = var.bastion_log_analytics_workspace_id
}

module "vms" {
  source = "git::https://github.com/nluwv/AZLABS-cnc-azurerm-vms.git?ref=main"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  biv                 = var.biv
  tags                = var.tags
  admin_passwords     = var.admin_passwords

  vms = merge(
    var.enable_linux_vm ? {
      linux = {
        name                   = local.linux_vm_name
        nic_name               = local.linux_nic_name
        os_type                = "linux"
        subnet_id              = module.network.subnet_ids[local.management_subnet]
        size                   = var.linux_vm.size
        admin_username         = var.linux_vm.admin_username
        admin_ssh_public_key   = var.linux_vm.admin_ssh_public_key
        source_image_id        = var.linux_vm.source_image_id
        source_image_reference = var.linux_vm.source_image_reference
        os_disk                = var.linux_vm.os_disk
      }
    } : {},
    var.enable_windows_vm ? {
      windows = {
        name                   = local.windows_vm_name
        nic_name               = local.windows_nic_name
        os_type                = "windows"
        subnet_id              = module.network.subnet_ids[local.management_subnet]
        size                   = var.windows_vm.size
        admin_username         = var.windows_vm.admin_username
        source_image_id        = var.windows_vm.source_image_id
        source_image_reference = var.windows_vm.source_image_reference
        plan                   = var.windows_vm.plan
        os_disk                = var.windows_vm.os_disk
      }
    } : {}
  )
}

resource "azurerm_role_assignment" "vm_admin_login" {
  for_each             = local.vm_admin_login_assignments
  scope                = module.vms.vm_ids[each.value.vm_key]
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = each.value.principal_id
}

resource "azurerm_role_assignment" "vm_user_login" {
  for_each             = local.vm_user_login_assignments
  scope                = module.vms.vm_ids[each.value.vm_key]
  role_definition_name = "Virtual Machine User Login"
  principal_id         = each.value.principal_id
}

resource "azurerm_role_assignment" "vm_reader" {
  for_each             = local.vm_reader_assignments
  scope                = module.vms.vm_ids[each.value.vm_key]
  role_definition_name = "Reader"
  principal_id         = each.value.principal_id
}

data "azurerm_role_definition" "pim_vm_admin_login" {
  for_each = var.enable_pim_eligible_role_assignments ? local.vm_admin_login_assignments : {}

  name  = "Virtual Machine Administrator Login"
  scope = module.vms.vm_ids[each.value.vm_key]
}

data "azurerm_role_definition" "pim_vm_user_login" {
  for_each = var.enable_pim_eligible_role_assignments ? local.vm_user_login_assignments : {}

  name  = "Virtual Machine User Login"
  scope = module.vms.vm_ids[each.value.vm_key]
}

resource "azurerm_pim_eligible_role_assignment" "vm_admin_login" {
  for_each = var.enable_pim_eligible_role_assignments ? local.vm_admin_login_assignments : {}

  scope              = module.vms.vm_ids[each.value.vm_key]
  role_definition_id = data.azurerm_role_definition.pim_vm_admin_login[each.key].role_definition_id
  principal_id       = each.value.principal_id
  justification      = "Eligible VM Administrator Login assignment for jumphost access."

  schedule {
    expiration {
      duration_days = var.pim_eligible_assignment_duration_days
    }
  }
}

resource "azurerm_pim_eligible_role_assignment" "vm_user_login" {
  for_each = var.enable_pim_eligible_role_assignments ? local.vm_user_login_assignments : {}

  scope              = module.vms.vm_ids[each.value.vm_key]
  role_definition_id = data.azurerm_role_definition.pim_vm_user_login[each.key].role_definition_id
  principal_id       = each.value.principal_id
  justification      = "Eligible VM User Login assignment for jumphost access."

  schedule {
    expiration {
      duration_days = var.pim_eligible_assignment_duration_days
    }
  }
}
