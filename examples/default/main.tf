terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26"
    }
  }
}

module "bootstrap" {
  source = "../.."

  workload    = "tfstate"
  environment = "dev"
  location    = "westeurope"
  region_code = "we"
  instance    = "01"
  biv         = "233"

  github_owner      = "xx"
  github_repository = "platform-workloads"
}
