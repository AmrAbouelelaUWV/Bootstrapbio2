resource "azurerm_virtual_network" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = local.tags
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints

  dynamic "delegation" {
    for_each = each.value.delegations

    content {
      name = delegation.key

      service_delegation {
        name    = delegation.value.service_name
        actions = delegation.value.actions
      }
    }
  }
}

resource "azurerm_network_security_group" "this" {
  for_each = var.network_security_groups

  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.tags

  dynamic "security_rule" {
    for_each = each.value.security_rules

    content {
      name                         = security_rule.key
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_range            = length(security_rule.value.source_port_ranges) == 1 ? security_rule.value.source_port_ranges[0] : null
      source_port_ranges           = length(security_rule.value.source_port_ranges) > 1 ? security_rule.value.source_port_ranges : null
      destination_port_range       = length(security_rule.value.destination_port_ranges) == 1 ? security_rule.value.destination_port_ranges[0] : null
      destination_port_ranges      = length(security_rule.value.destination_port_ranges) > 1 ? security_rule.value.destination_port_ranges : null
      source_address_prefix        = length(security_rule.value.source_address_prefixes) == 1 ? security_rule.value.source_address_prefixes[0] : null
      source_address_prefixes      = length(security_rule.value.source_address_prefixes) > 1 ? security_rule.value.source_address_prefixes : null
      destination_address_prefix   = length(security_rule.value.destination_address_prefixes) == 1 ? security_rule.value.destination_address_prefixes[0] : null
      destination_address_prefixes = length(security_rule.value.destination_address_prefixes) > 1 ? security_rule.value.destination_address_prefixes : null
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = var.network_security_groups

  subnet_id                 = azurerm_subnet.this[each.value.subnet_name].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}

resource "azurerm_route_table" "this" {
  for_each = var.route_tables

  name                          = each.key
  resource_group_name           = var.resource_group_name
  location                      = var.location
  bgp_route_propagation_enabled = each.value.bgp_route_propagation_enabled
  tags                          = local.tags

  dynamic "route" {
    for_each = each.value.routes

    content {
      name                   = route.key
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each = var.route_table_associations

  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = azurerm_route_table.this[each.value.route_table_name].id
}

resource "azurerm_virtual_network_peering" "this" {
  for_each = var.peerings

  name                         = each.key
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.this.name
  remote_virtual_network_id    = each.value.remote_virtual_network_id
  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways
}

resource "azurerm_private_dns_zone" "this" {
  for_each = var.private_dns_zones

  name                = each.key
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = var.private_dns_zones

  name                  = each.value.link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this[each.key].name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = each.value.registration_enabled
  tags                  = local.tags
}
