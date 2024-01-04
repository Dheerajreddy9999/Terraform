#vnet-values
resource_group_name   = "aks-rg"
location              = "Korea Central"
virtual_network_name  = "aks-vnet"
vnet_address_space    = "10.1.0.0/16"
subnet_name           = "aks-subnet"
subnet_address_prefix = "10.1.0.0/24"

#aks-values
aks_cluster_name      = "aks-1"
dns_prefix            = "aks-1"
kubernetes_version    = "1.28.3"
node_resource_group   = "aks-rg-node-pool"
admin_username        = "ubuntu"
ssh_key               = "~/.ssh/id_rsa.pub"
node_count            = "1"
vm_Size               = "Standard_D2_v2"
os_disk_size_gb       = "40"
max_count             = 4
min_count             = 1
enable_node_public_ip = true
sku_tier              = "Free"