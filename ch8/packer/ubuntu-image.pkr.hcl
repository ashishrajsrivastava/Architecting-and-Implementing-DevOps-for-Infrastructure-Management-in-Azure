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
  image_offer                       = "0001-com-ubuntu-server-jammy"
  image_publisher                   = "canonical"
  image_sku                         = "22_04-lts"
  location                          = "East US"
  managed_image_name                = "adpUbuntuImage"
  managed_image_resource_group_name = "adp-image-rg"
  os_type                           = "Linux"
  subscription_id                   = "996ec04d-f171-4281-a17b-ca0209711e2b"
  tenant_id                         = "56f16848-e5f8-4724-8e37-be5ef8afa71a"
  vm_size                           = "Standard_DS2_v2"
}

build {
  sources = ["source.azure-arm.nginx-image"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["apt-get update", "apt-get upgrade -y", "apt-get -y install nginx", "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    inline_shebang  = "/bin/sh -x"
  }

}