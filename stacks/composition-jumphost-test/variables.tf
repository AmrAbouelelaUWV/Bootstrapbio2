variable "workload" {
  description = "Short workload name used in resource names."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,30}$", var.workload))
    error_message = "Workload must be lowercase, start with a letter, and contain only letters, numbers, or hyphens."
  }
}

variable "environment" {
  description = "Environment code, for example o, t, a, p, dev, acc, or prd."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{1,5}$", var.environment))
    error_message = "Environment must be a short lowercase code (for example o, t, a, p, dev, acc, or prd)."
  }
}

variable "location" {
  description = "Azure region name."
  type        = string
}

variable "region_code" {
  description = "Short region code, for example we, ne, or eus."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{2,4}$", var.region_code))
    error_message = "Region code must be a short lowercase code."
  }
}

variable "instance" {
  description = "Two digit resource instance number."
  type        = string
  default     = "01"

  validation {
    condition     = can(regex("^[0-9]{2}$", var.instance))
    error_message = "Instance must be two digits."
  }
}

variable "address_space" {
  description = "Virtual network address spaces for the jumphost network."
  type        = list(string)
}

variable "management_subnet_prefix" {
  description = "CIDR prefix for the management VM subnet."
  type        = string
}

variable "private_endpoint_subnet_prefix" {
  description = "Optional CIDR prefix for a dedicated private endpoint subnet in the management VNet."
  type        = string
  default     = null
}

variable "bastion_address_space" {
  description = "Address space for the dedicated Bastion access VNet."
  type        = list(string)
}

variable "bastion_subnet_prefix" {
  description = "CIDR prefix for AzureBastionSubnet in the dedicated Bastion access VNet. Basic and Standard Bastion require /26 or larger."
  type        = string
}

variable "bastion_sku" {
  description = "Azure Bastion SKU. Basic and Standard are supported by this stack."
  type        = string
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard"], var.bastion_sku)
    error_message = "Bastion SKU must be Basic or Standard."
  }
}

variable "availability_zones" {
  description = "Availability zones for the Bastion public IP."
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "bastion_log_analytics_workspace_id" {
  description = "Optional Log Analytics workspace ID for Bastion diagnostics."
  type        = string
  default     = null
}

variable "enable_nat_gateway" {
  description = "When true, create and attach a NAT gateway to the management subnet."
  type        = bool
  default     = false
}

variable "nat_gateway" {
  description = "NAT gateway settings."
  type = object({
    sku_name            = optional(string, "Standard")
    idle_timeout_minutes = optional(number, 4)
    availability_zones  = optional(list(string), ["1", "2", "3"])
  })
  default = {}
}

variable "private_endpoints" {
  description = "Private endpoints keyed by logical name."
  type = map(object({
    target_resource_id            = string
    subresource_names             = optional(list(string), ["vault"])
    private_dns_zone_ids          = optional(list(string), [])
    subnet_name                   = optional(string)
    private_service_connection_name = optional(string)
    ip_configuration_name         = optional(string)
  }))
  default = {}
}

variable "des" {
  description = "Optional disk encryption set settings for VM OS disks."
  type = object({
    enabled          = optional(bool, false)
    name             = optional(string)
    key_vault_key_id = optional(string)
    key_vault_id     = optional(string)
  })
  default = {}
}

variable "policy_assignments" {
  description = "Resource-group scoped policy assignments keyed by assignment name."
  type = map(object({
    policy_definition_id = string
    description          = optional(string)
    enforce              = optional(bool, true)
    parameters           = optional(string, null)
  }))
  default = {}
}

variable "defender_plans" {
  description = "Defender for Cloud subscription plans keyed by resource type (for example VirtualMachines)."
  type = map(object({
    tier    = optional(string, "Standard")
    subplan = optional(string)
  }))
  default = {}
}

variable "activity_log" {
  description = "Optional Activity Log diagnostic setting at subscription scope."
  type = object({
    enabled                    = optional(bool, false)
    name                       = optional(string, "activity-log-to-law")
    log_analytics_workspace_id = optional(string)
    storage_account_id         = optional(string)
  })
  default = {}
}

variable "update_manager" {
  description = "Optional Azure Update Manager settings."
  type = object({
    enabled               = optional(bool, false)
    configuration_name    = optional(string)
    window_start_date_time = optional(string, "2026-01-01 02:00")
    window_duration        = optional(string, "03:00")
    window_time_zone       = optional(string, "UTC")
    recur_every            = optional(string, "Week Saturday")
  })
  default = {}
}

variable "backup" {
  description = "Optional Recovery Services and VM backup settings."
  type = object({
    enabled                         = optional(bool, false)
    vault_name                      = optional(string)
    sku                             = optional(string, "Standard")
    soft_delete_enabled             = optional(bool, true)
    policy_name                     = optional(string, "daily-policy")
    timezone                        = optional(string, "UTC")
    backup_time                     = optional(string, "23:00")
    retention_daily_count           = optional(number, 30)
  })
  default = {}
}

variable "resource_locks" {
  description = "Optional CanNotDelete locks on critical resources."
  type = object({
    enabled = optional(bool, false)
    level   = optional(string, "CanNotDelete")
    notes   = optional(string, "Managed by Terraform lock policy")
  })
  default = {}
}

variable "enable_linux_vm" {
  description = "When true, create the Linux management VM."
  type        = bool
  default     = true
}

variable "enable_windows_vm" {
  description = "When true, create the Windows management VM."
  type        = bool
  default     = true
}

variable "linux_vm" {
  description = "Linux management VM configuration."
  type = object({
    size                 = optional(string, "Standard_B2s")
    admin_username       = optional(string, "azureadmin")
    admin_ssh_public_key = optional(string)
    source_image_id      = optional(string)
    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
      }), {
      publisher = "Canonical"
      offer     = "ubuntu-24_04-lts"
      sku       = "server"
      version   = "latest"
    })
    os_disk = optional(object({
      caching              = optional(string, "ReadWrite")
      storage_account_type = optional(string, "StandardSSD_LRS")
    }), {})
  })
  default = {}
}

variable "windows_vm" {
  description = "Windows management VM configuration."
  type = object({
    size            = optional(string, "Standard_B2s")
    admin_username  = optional(string, "zauadmin")
    source_image_id = optional(string)
    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
      }), {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-datacenter-azure-edition"
      version   = "latest"
    })
    plan = optional(object({
      name      = string
      product   = string
      publisher = string
    }))
    os_disk = optional(object({
      caching              = optional(string, "ReadWrite")
      storage_account_type = optional(string, "StandardSSD_LRS")
    }), {})
  })
  default = {}
}

variable "admin_passwords" {
  description = "Windows admin passwords keyed by VM logical name. Supply from a secret source, not tfvars."
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "admin_login_principal_ids" {
  description = "Principal IDs keyed by group or principal name for Virtual Machine Administrator Login on all management VMs."
  type        = map(string)
  default     = {}
}

variable "user_login_principal_ids" {
  description = "Principal IDs keyed by group or principal name for Virtual Machine User Login on all management VMs."
  type        = map(string)
  default     = {}
}

variable "enable_pim_eligible_role_assignments" {
  description = "When true, create PIM eligible VM login role assignments."
  type        = bool
  default     = false
}

variable "pim_eligible_assignment_duration_days" {
  description = "Duration in days for PIM eligible role assignments."
  type        = number
  default     = 365
}

variable "biv" {
  description = "Security classification tag, beschikbaarheid-integriteit-vertrouwelijkheid, 1=high 2=medium 3=low."
  type        = string

  validation {
    condition     = can(regex("^[1-3]{3}$", var.biv))
    error_message = "BIV must be three digits between 1 and 3, for example 122."
  }
}

variable "tags" {
  description = "Additional tags. Stack-owned required tags take precedence."
  type        = map(string)
  default     = {}
}
