variable "resource_group_name" {
  description = "Resource group for Terraform state storage and related bootstrap resources."
  type        = string
}

variable "location" {
  description = "Azure location for the bootstrap resources."
  type        = string
  default     = "eastus"
}

variable "storage_account_name" {
  description = "Globally unique storage account name for Terraform state."
  type        = string
}

variable "container_name" {
  description = "Storage container name that stores Terraform states."
  type        = string
}

variable "tags" {
  description = "Tags for bootstrap resources."
  type        = map(string)
}
