# create a VM using terraform

terraform init
terraform apply -auto-approve ./main.tf

az vm create --resource-group adp-image-rg --name myVM --image adpUbuntuImage --admin-username azureuser --generate-ssh-keys

az vm open-port --resource-group adp-image-rg --name myVM --port 80