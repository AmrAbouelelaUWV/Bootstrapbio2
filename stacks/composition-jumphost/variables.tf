variable "workload" {
  description = "Short workload name used in resource names."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,30}$", var.workload))
    error_message = "Workload must be lowercase, start with a letter, and contain only letters, numbers, or hyphens."
  }
}

variable "environment" {
  description = "Environment code, for example dev, acc, or prd."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{1,5}$", var.environment))
    error_message = "Environment must be a short lowercase code."
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
