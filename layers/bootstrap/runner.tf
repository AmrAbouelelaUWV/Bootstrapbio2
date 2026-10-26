locals {
  bootstrap_network_enabled            = var.self_hosted_runner_enabled || var.private_endpoint_enabled || var.network_rules_enabled
  private_endpoint_subnet_id           = var.private_endpoint_subnet_id != null ? var.private_endpoint_subnet_id : (local.bootstrap_network_enabled ? azurerm_subnet.private_endpoint[0].id : null)
  private_dns_zone_virtual_network_id  = var.private_dns_zone_virtual_network_id != null ? var.private_dns_zone_virtual_network_id : (local.bootstrap_network_enabled ? azurerm_virtual_network.bootstrap[0].id : null)
  private_dns_zone_resource_group_name = var.private_dns_zone_resource_group_name != null ? var.private_dns_zone_resource_group_name : azurerm_resource_group.tfstate.name
}

resource "azurerm_virtual_network" "bootstrap" {
  count               = local.bootstrap_network_enabled ? 1 : 0
  name                = "bootstrap-vnet"
  location            = azurerm_resource_group.tfstate.location
  resource_group_name = azurerm_resource_group.tfstate.name
  address_space       = var.bootstrap_network_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "self_hosted_runner" {
  count                = local.bootstrap_network_enabled ? 1 : 0
  name                 = "runner"
  resource_group_name  = azurerm_resource_group.tfstate.name
  virtual_network_name = azurerm_virtual_network.bootstrap[0].name
  address_prefixes     = var.self_hosted_runner_subnet_prefixes
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "containerapps"

    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "private_endpoint" {
  count                = local.bootstrap_network_enabled ? 1 : 0
  name                 = "private-endpoints"
  resource_group_name  = azurerm_resource_group.tfstate.name
  virtual_network_name = azurerm_virtual_network.bootstrap[0].name
  address_prefixes     = var.private_endpoint_subnet_prefixes

  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_log_analytics_workspace" "self_hosted_runner" {
  count               = var.self_hosted_runner_enabled ? 1 : 0
  name                = "${var.self_hosted_runner_job_name}-law"
  location            = azurerm_resource_group.tfstate.location
  resource_group_name = azurerm_resource_group.tfstate.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_container_app_environment" "self_hosted_runner" {
  count                      = var.self_hosted_runner_enabled ? 1 : 0
  name                       = var.self_hosted_runner_environment_name
  resource_group_name        = azurerm_resource_group.tfstate.name
  location                   = azurerm_resource_group.tfstate.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.self_hosted_runner[0].id
  infrastructure_subnet_id   = azurerm_subnet.self_hosted_runner[0].id
  tags                       = var.tags
}

resource "azurerm_container_app_job" "self_hosted_runner" {
  count                        = var.self_hosted_runner_enabled ? 1 : 0
  name                         = var.self_hosted_runner_job_name
  resource_group_name          = azurerm_resource_group.tfstate.name
  location                     = azurerm_resource_group.tfstate.location
  container_app_environment_id = azurerm_container_app_environment.self_hosted_runner[0].id
  replica_timeout_in_seconds   = var.self_hosted_runner_job_timeout_in_seconds
  replica_retry_limit          = 0
  tags                         = var.tags

  identity {
    type = "SystemAssigned"
  }

  secret {
    name  = "runner-token"
    value = "placeholder"
  }

  manual_trigger_config {
    parallelism              = 1
    replica_completion_count = 1
  }

  template {
    container {
      name    = "runner"
      image   = var.self_hosted_runner_image
      cpu     = var.self_hosted_runner_cpu
      memory  = var.self_hosted_runner_memory
      command = ["/bin/bash"]
      args = [
        "-lc",
        <<-EOT
set -euo pipefail

if [[ -z "$${RUNNER_TOKEN:-}" ]]; then
  echo "RUNNER_TOKEN is required." >&2
  exit 1
fi

if [[ -z "$${GITHUB_REPOSITORY:-}" ]]; then
  echo "GITHUB_REPOSITORY is required." >&2
  exit 1
fi

RUNNER_NAME="$${RUNNER_NAME:-}"
if [[ -z "$RUNNER_NAME" ]]; then
  RUNNER_NAME="$HOSTNAME"
fi

RUNNER_LABEL="$${RUNNER_LABEL:-}"
if [[ -z "$RUNNER_LABEL" ]]; then
  RUNNER_LABEL="${var.self_hosted_runner_label}"
fi

RUNNER_DIR="/opt/actions-runner"

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl jq tar ca-certificates libicu-dev

mkdir -p "$RUNNER_DIR"
cd "$RUNNER_DIR"

latest_version="$(curl -fsSL https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name | ltrimstr("v")')"
curl -fsSL -o actions-runner.tar.gz "https://github.com/actions/runner/releases/download/v$${latest_version}/actions-runner-linux-x64-$${latest_version}.tar.gz"
tar xzf actions-runner.tar.gz

./config.sh --unattended \
  --url "https://github.com/$${GITHUB_REPOSITORY}" \
  --token "$${RUNNER_TOKEN}" \
  --name "$RUNNER_NAME" \
  --labels "$RUNNER_LABEL" \
  --work "_work" \
  --ephemeral \
  --replace

./run.sh
        EOT
      ]

      env {
        name        = "RUNNER_TOKEN"
        secret_name = "runner-token"
      }

      env {
        name  = "GITHUB_REPOSITORY"
        value = coalesce(var.self_hosted_runner_repository, "")
      }

      env {
        name  = "RUNNER_LABEL"
        value = var.self_hosted_runner_label
      }

      env {
        name  = "RUNNER_NAME"
        value = "${var.self_hosted_runner_job_name}-ephemeral"
      }
    }
  }

  lifecycle {
    precondition {
      condition     = !var.self_hosted_runner_enabled || coalesce(var.self_hosted_runner_repository, "") != ""
      error_message = "self_hosted_runner_repository is required when self_hosted_runner_enabled is true."
    }
  }
}