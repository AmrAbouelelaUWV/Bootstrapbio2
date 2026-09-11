locals {
  suffix              = "${var.workload}-${var.environment}-${var.region_code}-${var.instance}"
  tags                = merge(var.tags, { biv = var.biv })
  resource_group_name = "rg-bas-${local.suffix}"
  network_name        = "vnet-bas-${local.suffix}"
  bastion_subnet_name = "AzureBastionSubnet"
  bastion_nsg_name    = "nsg-bas-${local.suffix}"
  bastion_name        = "bas-${local.suffix}"
  public_ip_name      = "pip-bas-${local.suffix}"
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.tags
}

module "network" {
  source = "../../modules/network"

  name                = local.network_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = var.address_space
  biv                 = var.biv
  tags                = var.tags

  subnets = {
    (local.bastion_subnet_name) = {
      address_prefixes = [var.bastion_subnet_prefix]
    }
  }

  network_security_groups = {
    (local.bastion_nsg_name) = {
      subnet_name = local.bastion_subnet_name
      security_rules = {
        AllowHttpsInbound = {
          priority                     = 120
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_ranges           = ["*"]
          destination_port_ranges      = ["443"]
          source_address_prefixes      = ["Internet"]
          destination_address_prefixes = ["*"]
        }

        AllowGatewayManagerInbound = {
          priority                     = 130
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_ranges           = ["*"]
          destination_port_ranges      = ["443"]
          source_address_prefixes      = ["GatewayManager"]
          destination_address_prefixes = ["*"]
        }

        AllowAzureLoadBalancerInbound = {
          priority                     = 140
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_ranges           = ["*"]
          destination_port_ranges      = ["443"]
          source_address_prefixes      = ["AzureLoadBalancer"]
          destination_address_prefixes = ["*"]
        }

        AllowBastionHostCommunication = {
          priority                     = 150
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "*"
          source_port_ranges           = ["*"]
          destination_port_ranges      = ["8080", "5701"]
          source_address_prefixes      = ["VirtualNetwork"]
          destination_address_prefixes = ["VirtualNetwork"]
        }

        AllowSshRdpOutbound = {
          priority                     = 100
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "*"
          source_port_ranges           = ["*"]
          destination_port_ranges      = ["22", "3389"]
          source_address_prefixes      = ["*"]
          destination_address_prefixes = ["VirtualNetwork"]
        }

        AllowAzureCloudOutbound = {
          priority                     = 110
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_ranges           = ["*"]
          destination_port_ranges      = ["443"]
          source_address_prefixes      = ["*"]
          destination_address_prefixes = ["AzureCloud"]
        }

        AllowBastionCommunication = {
          priority                     = 120
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "*"
          source_port_ranges           = ["*"]
          destination_port_ranges      = ["8080", "5701"]
          source_address_prefixes      = ["VirtualNetwork"]
          destination_address_prefixes = ["VirtualNetwork"]
        }

        AllowGetSessionInformation = {
          priority                     = 130
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "*"
          source_port_ranges           = ["*"]
          destination_port_ranges      = ["80"]
          source_address_prefixes      = ["*"]
          destination_address_prefixes = ["Internet"]
        }
      }
    }
  }

  peerings = {
    (var.target_peering_name) = {
      remote_virtual_network_id    = var.target_virtual_network_id
      allow_virtual_network_access = true
      allow_forwarded_traffic      = false
      allow_gateway_transit        = false
      use_remote_gateways          = false
    }
  }
}

resource "azurerm_virtual_network_peering" "target_to_bastion" {
  name                         = var.target_reverse_peering_name
  resource_group_name          = var.target_virtual_network_resource_group_name
  virtual_network_name         = var.target_virtual_network_name
  remote_virtual_network_id    = module.network.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_public_ip" "this" {
  name                = local.public_ip_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.availability_zones
  tags                = local.tags
}

resource "azurerm_bastion_host" "this" {
  name                = local.bastion_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = var.bastion_sku
  copy_paste_enabled  = true
  file_copy_enabled   = var.bastion_sku == "Standard" ? true : null
  tunneling_enabled   = var.bastion_sku == "Standard" ? true : null
  tags                = local.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = module.network.subnet_ids[local.bastion_subnet_name]
    public_ip_address_id = azurerm_public_ip.this.id
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  count = var.log_analytics_workspace_id != null ? 1 : 0

  name                       = "diag-${local.bastion_name}"
  target_resource_id         = azurerm_bastion_host.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "BastionAuditLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
