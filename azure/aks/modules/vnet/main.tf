resource "azurerm_virtual_network" "dm-vnet" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_space]
}

resource "azurerm_subnet" "dm-subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.dm-vnet.name
  address_prefixes     = [var.subnet_address_prefix]
}
