
# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.azure_subscription_id}"
  client_id       = "${var.azure_client_id}"
  client_secret   = "${var.azure_client_secret}"
  tenant_id       = "${var.azure_tenant_id}"
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "myterraformgroup" {
  name     = "${var.rg_name}"
  location = "${var.location}"

  tags {
    environment = "${var.env}"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "Test_VNET_${var.env}"
  address_space       = ["${var.address_space}"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"

  tags {
    environment = "${var.env}"
  }
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
  name                 = "Subnet0"
  resource_group_name  = "${azurerm_resource_group.myterraformgroup.name}"
  virtual_network_name = "${azurerm_virtual_network.myterraformnetwork.name}"
  address_prefix       = "${var.subnet_block}"
}
#
# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
  name                         = "Test_PubIP_${var.env}"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.myterraformgroup.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    environment = "${var.env}"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "Test_NSG_${var.env}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "52.138.219.235"
    destination_address_prefix = "*"
  }

  tags {
    environment = "${var.env}"
  }
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
  name                      = "Test_NIC_${var.env}"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.myterraformgroup.name}"
  network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"

  ip_configuration {
    name                          = "Test_NIC_${var.env}"
    subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.myterraformpublicip.id}"
  }

  tags {
    environment = "${var.env}"
  }
}


# Create virtual machine
resource "azurerm_virtual_machine" "myterraformvm" {
  name                  = "${var.vm_name}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.myterraformgroup.name}"
  network_interface_ids = ["${azurerm_network_interface.myterraformnic.id}"]
  vm_size               = "${var.vm_size}"

  storage_os_disk {
    name              = "${var.vm_name}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {

    publisher = "${var.vm_publisher}"
    offer     = "${var.vm_distro}"
    sku       = "${var.vm_version}"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.vm_name}"
    admin_username = "azureuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "ssh-rsa CHANGE_ME=="
    }
  }

  tags {
    environment = "${var.env}"
  }
}
