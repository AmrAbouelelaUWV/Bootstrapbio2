variable "resource_group_name" {
  description = "Resource group where the virtual machines are created."
  type        = string
}

variable "location" {
  description = "Azure region for the virtual machines."
  type        = string
}

variable "vms" {
  description = "Management VMs keyed by logical name. Supports Linux and Windows VMs."
  type = map(object({
    name                 = string
    nic_name             = string
    os_type              = string
    subnet_id            = string
    disk_encryption_set_id = optional(string)
    encryption_at_host_enabled = optional(bool, false)
    size                 = optional(string, "Standard_B2s")
    admin_username       = optional(string, "azureadmin")
    admin_ssh_public_key = optional(string)
    source_image_id      = optional(string)
    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }))
    plan = optional(object({
      name      = string
      product   = string
      publisher = string
    }))
    os_disk = optional(object({
      caching              = optional(string, "ReadWrite")
      storage_account_type = optional(string, "StandardSSD_LRS")
    }), {})
  }))

  validation {
    condition = alltrue([
      for vm in values(var.vms) : contains(["linux", "windows"], vm.os_type)
    ])
    error_message = "Each VM os_type must be linux or windows."
  }

  validation {
    condition = alltrue([
      for vm in values(var.vms) : vm.source_image_id != null || vm.source_image_reference != null
    ])
    error_message = "Each VM must set source_image_id or source_image_reference."
  }

  validation {
    condition = alltrue([
      for vm in values(var.vms) : vm.os_type != "linux" || vm.admin_ssh_public_key != null
    ])
    error_message = "Linux VMs must set admin_ssh_public_key."
  }
}

variable "admin_passwords" {
  description = "Windows admin passwords keyed by VM logical name. Supply from a secret source, not tfvars."
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "boot_diagnostics_storage_account_uri" {
  description = "Optional storage account URI for boot diagnostics. Null uses managed boot diagnostics."
  type        = string
  default     = null
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
  description = "Additional tags. The module-owned biv tag takes precedence."
  type        = map(string)
  default     = {}
}
