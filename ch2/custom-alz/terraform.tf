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
    key                  = "prod.alz.terraform.tfstate"  
  }
}
provider "azurerm" {
  features {}
}