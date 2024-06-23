packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

source "azure-arm" "web-app-image" {
  azure_tags = {
    dept = "Engineering"
    task = "Image deployment"
  }
  use_azure_cli_auth                = true
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
  communicator                      = "ssh"
  ssh_username                      = "packer"
}

build {
  sources = ["source.azure-arm.web-app-image"]

  provisioner "ansible" {
    playbook_file = "packer/ansible/install-web-app.yml"
    user          = "packer"
    extra_arguments = [ "--scp-extra-args", "'-O'" ]
  }

}
