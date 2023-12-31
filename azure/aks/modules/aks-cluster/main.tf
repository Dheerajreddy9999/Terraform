resource "azurerm_kubernetes_cluster" "dm-cluster" {
  name                = var.aks_cluster_name
  resource_group_name = var.resource_group_name
  location            = var.location
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  node_resource_group = var.node_resource_group
  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = file(var.ssh_key)
    }
  }


  default_node_pool {
    name                  = "default"
    node_count            = var.node_count
    type                  = "VirtualMachineScaleSets"
    zones                 = [2, 3]
    os_disk_size_gb       = var.os_disk_size_gb
    vm_size               = var.vm_Size
    enable_auto_scaling   = true
    max_count             = var.max_count
    min_count             = var.min_count
    enable_node_public_ip = var.enable_node_public_ip
    vnet_subnet_id        = var.vnet_subnet_id


    node_labels = {
      environment = "dev"
      os          = "linux"
    }
  }



  network_profile {
    network_plugin    = "azure"
    network_policy    = "calico"
    load_balancer_sku = "standard"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
  }
}