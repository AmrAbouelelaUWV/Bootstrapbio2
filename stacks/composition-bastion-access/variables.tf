variable "workload" {
  description = "Short workload name used in resource names."
  type        = string
}

variable "environment" {
  description = "Environment code, for example dev, acc, or prd."
  type        = string
}

variable "location" {
  description = "Azure region name."
  type        = string
}

variable "region_code" {
  description = "Short region code, for example we, ne, or eus."
  type        = string
}

variable "instance" {
  description = "Two digit resource instance number."
  type        = string
  default     = "01"
}

variable "address_space" {
  description = "Address space for the dedicated Bastion VNet."
  type        = list(string)
}

variable "bastion_subnet_prefix" {
  description = "CIDR prefix for AzureBastionSubnet. Basic and Standard Bastion require /26 or larger."
  type        = string
}

variable "target_virtual_network_id" {
  description = "Target VNet ID that the Bastion access VNet peers to."
  type        = string
}

variable "target_virtual_network_name" {
  description = "Target VNet name for the reverse peering."
  type        = string
}

variable "target_virtual_network_resource_group_name" {
  description = "Resource group containing the target VNet for the reverse peering."
  type        = string
}

variable "target_peering_name" {
  description = "Peering name from the Bastion VNet to the target VNet."
  type        = string
  default     = "peer-bastion-to-target"
}

variable "target_reverse_peering_name" {
  description = "Peering name from the target VNet to the Bastion VNet."
  type        = string
  default     = "peer-target-to-bastion"
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

variable "log_analytics_workspace_id" {
  description = "Optional Log Analytics workspace ID for Bastion diagnostics."
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
  description = "Additional tags. Stack-owned required tags take precedence."
  type        = map(string)
  default     = {}
}
