variable "managed_rg_name" {
  description = "The name of the resource group where the managed image will be stored."
  type        = string
  default     = "adp-image-rg"
}

locals {
  image_offer = "0001-com-ubuntu-server-jammy"
  image_sku = "22_04-lts"
  image_name = "adpUbuntuImage"
  image_publisher = "canonical"
  os_type = "Linux"
  location = "East US"
  subscription_id = "996ec04d-f171-4281-a17b-ca0209711e2b"
  tenant_id = "56f16848-e5f8-4724-8e37-be5ef8afa71a"
  vm_size = "Standard_DS2_v2"
}

packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

source "azure-arm" "nginx-image" {
  azure_tags = {
    dept = "Engineering"
    task = "Image deployment"
  }
   use_azure_cli_auth               = true
  image_offer                       = locals.image_offer
  image_publisher                   = locals.image_publisher
  image_sku                         = locals.image_sku
  location                          = locals.location
  managed_image_name                = locals.image_name
  managed_image_resource_group_name = var.managed_rg_name
  os_type                           = locals.os_type
  subscription_id                   = locals.subscription_id
  tenant_id                         = locals.tenant_id
  vm_size                           = locals.vm_size
}

build {
  sources = ["source.azure-arm.nginx-image"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["apt-get update", "apt-get upgrade -y", "apt-get -y install nginx", "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    inline_shebang  = "/bin/sh -x"
  }

  post-processor "shell-local" {
    inline = ["Successfully created the managed image."]
  }

}