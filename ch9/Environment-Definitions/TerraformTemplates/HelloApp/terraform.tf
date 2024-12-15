terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.107.0"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "996ec04d-f171-4281-a17b-ca0209711e2b"
}