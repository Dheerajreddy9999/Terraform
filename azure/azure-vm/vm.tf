resource "azurerm_virtual_machine" "main" {
  name                  = "vm-1"
  location              = azurerm_resource_group.dm-rg.location
  resource_group_name   = azurerm_resource_group.dm-rg.name
  network_interface_ids = [azurerm_network_interface.dm-azurerm_network_security_group.id]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "web"
    admin_username = "dheeraj"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("~/.ssh/id_rsa.pub")
      path     = "/home/dheeraj/.ssh/authorized_keys"
    }
  }


  tags = {
    environment = "dev"
  }
}