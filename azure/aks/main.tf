resource "azurerm_resource_group" "dm-rg" {
  name     = var.resource_group_name
  location = var.location
}

module "vnet" {
  source                = "./modules/vnet"
  resource_group_name   = var.resource_group_name
  location              = var.location
  virtual_network_name  = var.virtual_network_name
  vnet_address_space    = var.vnet_address_space
  subnet_name           = var.subnet_name
  subnet_address_prefix = var.subnet_address_prefix

  depends_on = [azurerm_resource_group.dm-rg]
}


module "aks" {
  source                = "./modules/aks-cluster"
  aks_cluster_name      = var.aks_cluster_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  dns_prefix            = var.dns_prefix
  kubernetes_version    = var.kubernetes_version
  node_resource_group   = var.node_resource_group
  admin_username        = var.admin_username
  ssh_key               = var.ssh_key
  node_count            = var.node_count
  vm_Size               = var.vm_Size
  os_disk_size_gb       = var.os_disk_size_gb
  max_count             = var.max_count
  min_count             = var.min_count
  enable_node_public_ip = var.enable_node_public_ip
  vnet_subnet_id        = module.vnet.subnet_id

  depends_on = [module.vnet, azurerm_resource_group.dm-rg]
}