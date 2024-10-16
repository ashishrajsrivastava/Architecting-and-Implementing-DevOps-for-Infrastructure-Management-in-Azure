terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.107.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "iac-terraform-state-rg"
    storage_account_name = "iacbookstate2023"
    container_name       = "alzcoretfstate"
    key                  = "dev.alz.terraform.tfstate"  
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "core" {}

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "6.0.0"

  default_location = "westeurope"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = "iac-alz"
  root_name      = "IaC ALZ"
}