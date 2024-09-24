# create a resource group
az group create --name adp-image-rg --location eastus

# build packer image
sudo packer build -force ./packer/ubuntu-image-web-app.pkr.hcl
