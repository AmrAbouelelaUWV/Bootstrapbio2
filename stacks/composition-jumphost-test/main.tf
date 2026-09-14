locals {
  suffix = "${var.workload}-${var.environment}-${var.region_code}-${var.instance}"
  tags   = merge(var.tags, { biv = var.biv })

  resource_group_name = "rg-${local.suffix}"
  network_name        = "vnet-${local.suffix}"
  management_subnet   = "snet-management-${local.suffix}"
  private_endpoint_subnet = var.private_endpoint_subnet_prefix != null ? "snet-private-endpoints-${local.suffix}" : null
  management_nsg      = "nsg-management-${local.suffix}"
  linux_vm_name       = "vm-linux-${local.suffix}"
  linux_nic_name      = "nic-linux-${local.suffix}"
  windows_vm_name     = "vm-windows-${local.suffix}"
  windows_nic_name    = "nic-windows-${local.suffix}"

  nat_gateway_enabled = var.enable_nat_gateway
  des_enabled         = try(var.des.enabled, false) && try(var.des.key_vault_key_id, null) != null
  backup_enabled      = try(var.backup.enabled, false)
  update_enabled      = try(var.update_manager.enabled, false)
  lock_enabled        = try(var.resource_locks.enabled, false)

  private_endpoint_default_subnet = local.private_endpoint_subnet != null ? local.private_endpoint_subnet : local.management_subnet

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

  lock_scopes = merge(
    {
      resource_group = azurerm_resource_group.this.id
      network        = module.network.id
      bastion        = module.bastion_access.bastion_id
    },
    { for vm_key, vm_id in module.vms.vm_ids : "vm-${vm_key}" => vm_id },
    local.nat_gateway_enabled ? { nat_gateway = azurerm_nat_gateway.this[0].id } : {},
    local.des_enabled ? { disk_encryption_set = azurerm_disk_encryption_set.this[0].id } : {},
    local.backup_enabled ? { recovery_vault = azurerm_recovery_services_vault.this[0].id } : {}
  )
}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.tags
}

module "network" {
  source = "../../modules/network"

  name                = local.network_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = var.address_space
  biv                 = var.biv
  tags                = var.tags

  subnets = merge(
    {
      (local.management_subnet) = {
        address_prefixes = [var.management_subnet_prefix]
      }
    },
    local.private_endpoint_subnet != null ? {
      (local.private_endpoint_subnet) = {
        address_prefixes                        = [var.private_endpoint_subnet_prefix]
        private_endpoint_network_policies_state = "Disabled"
      }
    } : {}
  )

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
  source = "../composition-bastion-access"

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

resource "azurerm_public_ip" "nat" {
  count = local.nat_gateway_enabled ? 1 : 0

  name                = "pip-nat-${local.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.nat_gateway.availability_zones
  tags                = local.tags
}

resource "azurerm_nat_gateway" "this" {
  count = local.nat_gateway_enabled ? 1 : 0

  name                    = "nat-${local.suffix}"
  location                = azurerm_resource_group.this.location
  resource_group_name     = azurerm_resource_group.this.name
  sku_name                = var.nat_gateway.sku_name
  idle_timeout_in_minutes = var.nat_gateway.idle_timeout_minutes
  zones                   = var.nat_gateway.availability_zones
  tags                    = local.tags
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  count = local.nat_gateway_enabled ? 1 : 0

  nat_gateway_id       = azurerm_nat_gateway.this[0].id
  public_ip_address_id = azurerm_public_ip.nat[0].id
}

resource "azurerm_subnet_nat_gateway_association" "management" {
  count = local.nat_gateway_enabled ? 1 : 0

  subnet_id      = module.network.subnet_ids[local.management_subnet]
  nat_gateway_id = azurerm_nat_gateway.this[0].id
}

resource "azurerm_private_endpoint" "this" {
  for_each = var.private_endpoints

  name                = "pep-${each.key}-${local.suffix}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = module.network.subnet_ids[coalesce(try(each.value.subnet_name, null), local.private_endpoint_default_subnet)]
  tags                = local.tags

  private_service_connection {
    name                           = coalesce(try(each.value.private_service_connection_name, null), "psc-${each.key}-${local.suffix}")
    private_connection_resource_id = each.value.target_resource_id
    is_manual_connection           = false
    subresource_names              = each.value.subresource_names
  }

  dynamic "private_dns_zone_group" {
    for_each = length(each.value.private_dns_zone_ids) > 0 ? [1] : []

    content {
      name                 = coalesce(try(each.value.ip_configuration_name, null), "pdzg-${each.key}")
      private_dns_zone_ids = each.value.private_dns_zone_ids
    }
  }
}

resource "azurerm_disk_encryption_set" "this" {
  count = local.des_enabled ? 1 : 0

  name                = coalesce(try(var.des.name, null), "des-${local.suffix}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  key_vault_key_id    = var.des.key_vault_key_id
  tags                = local.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "des_crypto_user" {
  count = local.des_enabled && try(var.des.key_vault_id, null) != null ? 1 : 0

  scope                = var.des.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.this[0].identity[0].principal_id
}

module "vms" {
  source = "../../modules/vms"

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
        disk_encryption_set_id = local.des_enabled ? azurerm_disk_encryption_set.this[0].id : null
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
        disk_encryption_set_id = local.des_enabled ? azurerm_disk_encryption_set.this[0].id : null
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

resource "azurerm_resource_group_policy_assignment" "this" {
  for_each = var.policy_assignments

  name                 = each.key
  resource_group_id    = azurerm_resource_group.this.id
  policy_definition_id = each.value.policy_definition_id
  description          = try(each.value.description, null)
  enforce              = each.value.enforce
  parameters           = each.value.parameters
}

resource "azurerm_security_center_subscription_pricing" "this" {
  for_each = var.defender_plans

  resource_type = each.key
  tier          = each.value.tier
  subplan       = try(each.value.subplan, null)
}

resource "azurerm_monitor_diagnostic_setting" "activity_log" {
  count = try(var.activity_log.enabled, false) ? 1 : 0

  name                       = var.activity_log.name
  target_resource_id         = data.azurerm_subscription.current.id
  log_analytics_workspace_id = try(var.activity_log.log_analytics_workspace_id, null)
  storage_account_id         = try(var.activity_log.storage_account_id, null)

  enabled_log {
    category = "Administrative"
  }

  enabled_log {
    category = "Security"
  }

  enabled_log {
    category = "Policy"
  }

  enabled_log {
    category = "Recommendation"
  }

  enabled_log {
    category = "ServiceHealth"
  }

  enabled_log {
    category = "Alert"
  }

  enabled_log {
    category = "Autoscale"
  }

  enabled_log {
    category = "ResourceHealth"
  }
}

resource "azurerm_maintenance_configuration" "this" {
  count = local.update_enabled ? 1 : 0

  name                = coalesce(try(var.update_manager.configuration_name, null), "umc-${local.suffix}")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  scope               = "InGuestPatch"

  window {
    start_date_time = var.update_manager.window_start_date_time
    duration        = var.update_manager.window_duration
    time_zone       = var.update_manager.window_time_zone
    recur_every     = var.update_manager.recur_every
  }

  install_patches {
    linux {
      classifications_to_include = ["Critical", "Security"]
    }

    windows {
      classifications_to_include = ["Critical", "Security", "UpdateRollup"]
    }

    reboot = "IfRequired"
  }

  tags = local.tags
}

resource "azurerm_maintenance_assignment_virtual_machine" "this" {
  for_each = local.update_enabled ? module.vms.vm_ids : {}

  location                     = azurerm_resource_group.this.location
  maintenance_configuration_id = azurerm_maintenance_configuration.this[0].id
  virtual_machine_id           = each.value
}

resource "azurerm_recovery_services_vault" "this" {
  count = local.backup_enabled ? 1 : 0

  name                = coalesce(try(var.backup.vault_name, null), "rsv-${local.suffix}")
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = var.backup.sku
  soft_delete_enabled = var.backup.soft_delete_enabled
  tags                = local.tags
}

resource "azurerm_backup_policy_vm" "this" {
  count = local.backup_enabled ? 1 : 0

  name                = var.backup.policy_name
  resource_group_name = azurerm_resource_group.this.name
  recovery_vault_name = azurerm_recovery_services_vault.this[0].name
  timezone            = var.backup.timezone

  backup {
    frequency = "Daily"
    time      = var.backup.backup_time
  }

  retention_daily {
    count = var.backup.retention_daily_count
  }
}

resource "azurerm_backup_protected_vm" "this" {
  for_each = local.backup_enabled ? module.vms.vm_ids : {}

  resource_group_name = azurerm_resource_group.this.name
  recovery_vault_name = azurerm_recovery_services_vault.this[0].name
  source_vm_id        = each.value
  backup_policy_id    = azurerm_backup_policy_vm.this[0].id
}

resource "azurerm_management_lock" "critical" {
  for_each = local.lock_enabled ? local.lock_scopes : {}

  name       = "lock-${each.key}-${local.suffix}"
  scope      = each.value
  lock_level = var.resource_locks.level
  notes      = var.resource_locks.notes
}
