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
    key                  = "demo.ade.terraform.tfstate"  
  }
}
provider "azurerm" {
    subscription_id = "996ec04d-f171-4281-a17b-ca0209711e2b"
  features {}
}