resource "azurerm_virtual_network" "this" {
  name                = "main"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    env = local.env
  }

}