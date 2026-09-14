variable "name" {
  description = "Virtual network name."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{2,80}$", var.name))
    error_message = "Name must be lowercase and contain only letters, numbers, or hyphens."
  }
}

variable "resource_group_name" {
  description = "Resource group where the virtual network is created."
  type        = string
}

variable "location" {
  description = "Azure region for the virtual network."
  type        = string
}

variable "address_space" {
  description = "Virtual network address spaces."
  type        = list(string)

  validation {
    condition     = length(var.address_space) > 0
    error_message = "At least one address space is required."
  }
}

variable "dns_servers" {
  description = "Optional custom DNS servers for the virtual network."
  type        = list(string)
  default     = null
}

variable "subnets" {
  description = "Subnets keyed by subnet name."
  type = map(object({
    address_prefixes                        = list(string)
    service_endpoints                       = optional(list(string), [])
    private_endpoint_network_policies_state = optional(string, "Enabled")
    delegations = optional(map(object({
      service_name = string
      actions      = list(string)
    })), {})
  }))

  validation {
    condition     = length(var.subnets) > 0
    error_message = "At least one subnet is required."
  }
}

variable "network_security_groups" {
  description = "Network security groups keyed by NSG name. Each NSG attaches to one subnet."
  type = map(object({
    subnet_name = string
    security_rules = map(object({
      priority                     = number
      direction                    = string
      access                       = string
      protocol                     = string
      source_port_ranges           = list(string)
      destination_port_ranges      = list(string)
      source_address_prefixes      = list(string)
      destination_address_prefixes = list(string)
    }))
  }))
  default = {}

  validation {
    condition = alltrue([
      for nsg in values(var.network_security_groups) : contains(keys(var.subnets), nsg.subnet_name)
    ])
    error_message = "Each network security group must reference a subnet from var.subnets."
  }
}

variable "route_table_associations" {
  description = "Route table associations keyed by subnet name."
  type = map(object({
    route_table_name = string
  }))
  default = {}

  validation {
    condition = alltrue([
      for subnet_name in keys(var.route_table_associations) : contains(keys(var.subnets), subnet_name)
    ])
    error_message = "Each route table association key must reference a subnet from var.subnets."
  }

  validation {
    condition = alltrue([
      for association in values(var.route_table_associations) : contains(keys(var.route_tables), association.route_table_name)
    ])
    error_message = "Each route table association must reference a route table from var.route_tables."
  }
}

variable "route_tables" {
  description = "Route tables keyed by route table name."
  type = map(object({
    bgp_route_propagation_enabled = optional(bool, true)
    routes = optional(map(object({
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    })), {})
  }))
  default = {}
}

variable "peerings" {
  description = "Outbound virtual network peerings from this VNet keyed by peering name."
  type = map(object({
    remote_virtual_network_id    = string
    allow_virtual_network_access = optional(bool, true)
    allow_forwarded_traffic      = optional(bool, false)
    allow_gateway_transit        = optional(bool, false)
    use_remote_gateways          = optional(bool, false)
  }))
  default = {}
}

variable "private_dns_zones" {
  description = "Private DNS zones keyed by zone name and linked to this virtual network."
  type = map(object({
    link_name            = string
    registration_enabled = optional(bool, false)
  }))
  default = {}
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
