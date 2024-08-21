output "aks-cluster-name" {
  value = azurerm_kubernetes_cluster.dm-cluster.name
}

output "aks-location" {
  value = azurerm_kubernetes_cluster.dm-cluster.location
}

output "k8s-version" {
  value = azurerm_kubernetes_cluster.dm-cluster.kubernetes_version
}


output "name" {
  value = azurerm_kubernetes_cluster.dm-cluster.kube_config_raw
}