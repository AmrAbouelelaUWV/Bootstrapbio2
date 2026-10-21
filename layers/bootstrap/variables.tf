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
  default     = false
}

variable "network_rules_enabled" {
  description = "Applies storage account network rules. When enabled, traffic is denied by default except for the configured bypasses, subnets, and IP rules."
  type        = bool
  default     = true
}

variable "network_bypass" {
  description = "Trusted Azure service bypasses for the storage account firewall."
  type        = list(string)
  default     = []
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
  default     = true
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

variable "cmk_enabled" {
  description = "Enables customer-managed key encryption for the Terraform state storage account."
  type        = bool
  default     = true
}

variable "cmk_key_vault_id" {
  description = "Key Vault resource ID that contains the CMK used for the Terraform state storage account."
  type        = string
  default     = null
}

variable "cmk_key_name" {
  description = "Key name in Key Vault used as customer-managed key for the Terraform state storage account."
  type        = string
  default     = null
}

variable "cmk_key_version" {
  description = "Optional key version in Key Vault. Leave null to use the latest key version."
  type        = string
  default     = null
}

variable "cmk_user_assigned_identity_id" {
  description = "Existing user-assigned managed identity resource ID used by the storage account to access the Key Vault key."
  type        = string
  default     = null
}

variable "cmk_user_assigned_identity_name" {
  description = "Name of the user-assigned managed identity created when CMK is enabled and no existing identity ID is provided."
  type        = string
  default     = "tfstate-cmk-uai"
}

variable "self_hosted_runner_enabled" {
  description = "Creates infrastructure for an ephemeral self-hosted GitHub Actions runner using an Azure Container Apps Job."
  type        = bool
  default     = false
}

variable "self_hosted_runner_job_name" {
  description = "Name of the self-hosted runner Container Apps Job."
  type        = string
  default     = "bootstrap-runner-job"
}

variable "self_hosted_runner_environment_name" {
  description = "Name of the Container Apps environment used for the ephemeral runner job."
  type        = string
  default     = "bootstrap-runner-env"
}

variable "self_hosted_runner_label" {
  description = "GitHub Actions label assigned to the self-hosted runner."
  type        = string
  default     = "bio2-runner"
}

variable "self_hosted_runner_image" {
  description = "Container image used for the ephemeral self-hosted runner job."
  type        = string
  default     = "ubuntu:22.04"
}

variable "self_hosted_runner_cpu" {
  description = "vCPU assigned to the ephemeral runner container."
  type        = number
  default     = 1
}

variable "self_hosted_runner_memory" {
  description = "Memory assigned to the ephemeral runner container."
  type        = string
  default     = "2Gi"
}

variable "self_hosted_runner_job_timeout_in_seconds" {
  description = "Maximum runtime in seconds for one ephemeral runner job execution."
  type        = number
  default     = 3600
}

variable "self_hosted_runner_repository" {
  description = "GitHub repository in owner/repo format used by the ephemeral runner for registration."
  type        = string
  default     = null
}

variable "bootstrap_network_address_space" {
  description = "Address space used for the bootstrap virtual network that hosts the runner and future private endpoints."
  type        = list(string)
  default     = ["10.42.0.0/16"]
}

variable "self_hosted_runner_subnet_prefixes" {
  description = "Subnet prefixes for the Container Apps runner environment subnet."
  type        = list(string)
  default     = ["10.42.1.0/24"]
}

variable "private_endpoint_subnet_prefixes" {
  description = "Subnet prefixes for the private endpoint subnet."
  type        = list(string)
  default     = ["10.42.2.0/24"]
}
