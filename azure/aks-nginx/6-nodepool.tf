# resource "azurerm_kubernetes_cluster_node_pool" "spot" {
#   name                  = "spot"
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
#   vm_size               = "Standard_DS2_v2"
#   orchestrator_version  = local.aks_version
#   vnet_subnet_id        = azurerm_subnet.subnet1.id
#   priority              = "Spot"
#   spot_max_price        = "-1"
#   eviction_policy       = "Delete"

#   enable_auto_scaling = true
#   min_count           = 1
#   max_count           = 5
#   node_count          = 1


#   node_labels = {
#     role                                    = "spot"
#     "kubernetes.azure.com/scalesetpriority" = "spot"
#   }

#   node_taints = [
#     "spot:NoSchedule",
#     "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
#   ]

#   lifecycle {
#     ignore_changes = [node_count]
#   }

#   tags = {
#     Environment = "Production"
#   }
# }