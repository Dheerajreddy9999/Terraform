# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}


provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}

resource "azurerm_resource_group" "dm-rg" {
  name     = "example-resources"
  location = "korea Central"

  tags = {
    environemnt = "dev"
  }
}

#vnet
resource "azurerm_virtual_network" "dm-vnet" {
  name                = "example-network"
  location            = azurerm_resource_group.dm-rg.location
  resource_group_name = azurerm_resource_group.dm-rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environemnt = "dev"
  }
}

#Subnet
resource "azurerm_subnet" "dm-sunnet" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.dm-rg.name
  virtual_network_name = azurerm_virtual_network.dm-vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

#Nsg
resource "azurerm_network_security_group" "dm-nsg" {
  name                = "example-nsg"
  resource_group_name = azurerm_resource_group.dm-rg.name
  location            = azurerm_resource_group.dm-rg.location

  tags = {
    environemnt = "dev"
  }
}

#Nsg-Rule
resource "azurerm_network_security_rule" "dm-nsg-rule" {
  name                        = "dev123"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dm-rg.name
  network_security_group_name = azurerm_network_security_group.dm-nsg.name
}

#Public IP
resource "azurerm_public_ip" "dm-public-ip" {
  name                = "test-ip-1"
  resource_group_name = azurerm_resource_group.dm-rg.name
  location            = azurerm_resource_group.dm-rg.location
  allocation_method   = "Static"

  tags = {
    environemnt = "dev"
  }
}

#Network Interface
resource "azurerm_network_interface" "dm-azurerm_network_security_group" {
  name                = "example-nic"
  location            = azurerm_resource_group.dm-rg.location
  resource_group_name = azurerm_resource_group.dm-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.dm-sunnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dm-public-ip.id
  }

  tags = {
    environemnt = "dev"
  }
}

#Network-Interface-Association with NSG
resource "azurerm_network_interface_security_group_association" "dm-nic-ass" {
  network_interface_id      = azurerm_network_interface.dm-azurerm_network_security_group.id
  network_security_group_id = azurerm_network_security_group.dm-nsg.id
}



output "publc-ip" {
  value = azurerm_public_ip.dm-public-ip.ip_address

}