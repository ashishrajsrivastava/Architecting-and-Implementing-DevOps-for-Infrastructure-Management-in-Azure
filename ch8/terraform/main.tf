data "azurerm_image" "adp_custom_image" {
  name                = "adpUbuntuImage"
  resource_group_name = "adp-image-rg"
}

resource "azurerm_resource_group" "custom_image_rg" {
  name     = "iac-book-customimage-vm-rg"
  location = "westeurope"
}

resource "azurerm_network_security_group" "custom_image_nsg" {
  name                = "cvm-nsg"
  location            = azurerm_resource_group.custom_image_rg.location
  resource_group_name = azurerm_resource_group.custom_image_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "custom_image_vnet" {
  name                = "cvm-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.custom_image_rg.location
  resource_group_name = azurerm_resource_group.custom_image_rg.name
}

resource "azurerm_subnet" "custom_image_subnet" {
  name                 = "cvm-subnet"
  resource_group_name  = azurerm_resource_group.custom_image_rg.name
  virtual_network_name = azurerm_virtual_network.custom_image_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "custom_image_pip" {
  name                = "cvm-pip"
  location            = azurerm_resource_group.custom_image_rg.location
  resource_group_name = azurerm_resource_group.custom_image_rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "custom_image_nic" {
  name                = "cvm-nic"
  location            = azurerm_resource_group.custom_image_rg.location
  resource_group_name = azurerm_resource_group.custom_image_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.custom_image_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.custom_image_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "custom_image_vm" {
  name                = "customimage-vm"
  resource_group_name = azurerm_resource_group.custom_image_rg.name
  location            = azurerm_resource_group.custom_image_rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password = "MyWebVM@123"
  disable_password_authentication = false
  
  network_interface_ids = [
    azurerm_network_interface.custom_image_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = data.azurerm_image.adp_custom_image.id
}
