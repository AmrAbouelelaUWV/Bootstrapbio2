variable "workload" {
  description = "Short bootstrap workload or capability name, for example tfstate."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,20}$", var.workload))
    error_message = "Workload must be lowercase, start with a letter, and contain only letters, numbers, or hyphens."
  }
}

variable "environment" {
  description = "Short naming code used in resource names and the GitHub OIDC subject."
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
  description = "Short region code used in resource names, for example we, ne, or eus."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{2,4}$", var.region_code))
    error_message = "Region code must be a short lowercase code."
  }
}

variable "instance" {
  description = "Two digit resource instance number used to keep names unique."
  type        = string
  default     = "01"

  validation {
    condition     = can(regex("^[0-9]{2}$", var.instance))
    error_message = "Instance must be two digits."
  }
}

variable "storage_account_unique_suffix" {
  description = "Optional lowercase alphanumeric suffix when the storage account name needs an extra unique segment."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-z0-9]{0,6}$", var.storage_account_unique_suffix))
    error_message = "Storage account suffix must be lowercase alphanumeric and at most 6 characters."
  }
}

variable "key_vault_unique_suffix" {
  description = "Optional lowercase alphanumeric suffix when the Key Vault name needs an extra unique segment."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-z0-9]{0,3}$", var.key_vault_unique_suffix))
    error_message = "Key Vault suffix must be lowercase alphanumeric and at most 3 characters."
  }
}

variable "subscription_id" {
  description = "Optional target subscription UUID. Defaults to the authenticated Azure context."
  type        = string
  default     = null

  validation {
    condition     = var.subscription_id == null || can(regex("^[0-9a-fA-F-]{36}$", var.subscription_id))
    error_message = "Subscription ID must be a UUID."
  }
}

variable "tenant_id" {
  description = "Optional tenant UUID. Defaults to the authenticated Azure context."
  type        = string
  default     = null

  validation {
    condition     = var.tenant_id == null || can(regex("^[0-9a-fA-F-]{36}$", var.tenant_id))
    error_message = "Tenant ID must be a UUID."
  }
}

variable "replication_type" {
  description = "Storage replication type."
  type        = string
  default     = "GRS"

  validation {
    condition     = contains(["LRS", "ZRS", "GRS", "GZRS"], var.replication_type)
    error_message = "Replication type must be LRS, ZRS, GRS, or GZRS."
  }
}

variable "blob_delete_retention_days" {
  description = "Soft-delete retention for state blobs."
  type        = number
  default     = 30
}

variable "container_delete_retention_days" {
  description = "Soft-delete retention for state containers."
  type        = number
  default     = 30
}

variable "key_vault_soft_delete_retention_days" {
  type    = number
  default = 90

  validation {
    condition     = var.key_vault_soft_delete_retention_days >= 7 && var.key_vault_soft_delete_retention_days <= 90
    error_message = "Key Vault soft-delete retention must be between 7 and 90 days."
  }
}

variable "github_owner" {
  description = "GitHub organization or user that owns the Terraform pipeline repository."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository allowed to federate as the Terraform pipeline identity."
  type        = string
}

variable "assign_subscription_contributor" {
  description = "When true, assign 'Contributor' to the pipeline identity at the subscription scope. Requires the caller to have permission to create subscription role assignments. When false the assignment will be created at the resource group scope instead."
  type        = bool
  default     = false
}

variable "create_role_assignments" {
  description = "When false, skip creating Azure role assignments. Useful when the caller lacks roleAssignment permissions; assign roles manually later."
  type        = bool
  default     = true
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
  description = "Additional tags. Bootstrap-owned required tags take precedence."
  type        = map(string)
  default     = {}
}

locals {
  storage_account_name_length_valid = length("sa${replace(var.workload, "-", "")}${var.environment}${var.region_code}${var.instance}${var.storage_account_unique_suffix}") <= 24
  key_vault_name_valid              = can(regex("^[a-z][a-z0-9-]{1,22}[a-z0-9]$", local.key_vault_name))
}

resource "terraform_data" "storage_account_name_validation" {
  input = local.storage_account_name_length_valid

  lifecycle {
    precondition {
      condition     = local.storage_account_name_length_valid
      error_message = "Storage account name must be at most 24 characters after removing workload hyphens and adding the optional suffix."
    }
  }
}

resource "terraform_data" "key_vault_name_validation" {
  input = local.key_vault_name_valid

  lifecycle {
    precondition {
      condition     = local.key_vault_name_valid
      error_message = "Key Vault name must be 3-24 characters, start with a letter, end with a letter or number, and contain only lowercase letters, numbers, or hyphens."
    }
  }
}
