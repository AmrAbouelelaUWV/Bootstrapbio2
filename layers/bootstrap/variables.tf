variable "resource_group_name" {
  description = "Resource group for Terraform state storage and related bootstrap resources."
  type        = string
}

variable "location" {
  description = "Azure location for the bootstrap resources."
  type        = string
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

variable "public_network_access_enabled" {
  description = "Keeps public network access enabled for the backend storage account. Disable only when Terraform runs from a network that can resolve and reach the private endpoint."
  type        = bool
  default     = true
}

variable "network_rules_enabled" {
  description = "Applies storage account network rules. When enabled, traffic is denied by default except for the configured bypasses, subnets, and IP rules."
  type        = bool
  default     = false
}

variable "network_bypass" {
  description = "Trusted Azure service bypasses for the storage account firewall."
  type        = list(string)
  default     = ["AzureServices"]
}

variable "allowed_subnet_ids" {
  description = "Subnet IDs that may reach the storage account over the public endpoint when network rules are enabled."
  type        = list(string)
  default     = []
}

variable "allowed_ip_rules" {
  description = "Public IP CIDR ranges that may reach the storage account when network rules are enabled."
  type        = list(string)
  default     = []
}

variable "private_endpoint_enabled" {
  description = "Creates a private endpoint for the blob service and links it to a private DNS zone."
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for the storage private endpoint. Required when private_endpoint_enabled is true."
  type        = string
  default     = null
}

variable "private_dns_zone_name" {
  description = "Private DNS zone name for the storage blob endpoint."
  type        = string
  default     = "privatelink.blob.core.windows.net"
}

variable "private_dns_zone_resource_group_name" {
  description = "Resource group that contains or will contain the private DNS zone. Defaults to the bootstrap resource group."
  type        = string
  default     = null
}

variable "private_dns_zone_virtual_network_id" {
  description = "Virtual network ID to link to the private DNS zone. Required when private_endpoint_enabled is true."
  type        = string
  default     = null
}

variable "blob_versioning_enabled" {
  description = "Enables blob versioning for Terraform state recovery."
  type        = bool
  default     = true
}

variable "change_feed_enabled" {
  description = "Enables the storage account change feed for auditability."
  type        = bool
  default     = true
}

variable "last_access_time_enabled" {
  description = "Enables last access time tracking on blobs."
  type        = bool
  default     = true
}

variable "blob_delete_retention_days" {
  description = "Retention in days for deleted blobs."
  type        = number
  default     = 30
}

variable "container_delete_retention_days" {
  description = "Retention in days for deleted blob containers."
  type        = number
  default     = 30
}
