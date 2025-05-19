resource "azurerm_user_assigned_identity" "base" {
  name                = "base"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_role_assignment" "base" {
  scope                = azurerm_resource_group.this.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.base.principal_id
}


resource "azurerm_kubernetes_cluster" "this" {
  name                = "${local.env}-${local.aks_name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = "exampleaks1"

  kubernetes_version        = local.aks_version
  automatic_channel_upgrade = "stable"
  private_cluster_enabled   = "false"
  sku_tier                  = "Free"

  # oidc_issuer_enabled       = "true"
  # workload_identity_enabled = "true"


  network_profile {
    network_plugin = "azure"
    dns_service_ip = "10.0.64.10"
    service_cidr   = "10.0.64.0/19"
  }


  default_node_pool {
    name                  = "default"
    vm_size               = "Standard_D2_v2"
    orchestrator_version  = local.aks_version
    vnet_subnet_id        = azurerm_subnet.subnet1.id
    enable_node_public_ip = "true"
    enable_auto_scaling   = "true"
    type                  = "VirtualMachineScaleSets"
    max_count             = 5
    min_count             = 1
    node_count            = 1

    tags = {
      env = local.env
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.base.id]
  }

  # identity {
  #   type = "SystemAssigned"
  # }

  tags = {
    env = local.env
  }

  depends_on = [azurerm_role_assignment.base]

}

