resource "azurerm_user_assigned_identity" "dev_test" {
  location            = azurerm_resource_group.this.location
  name                = "dev-test"
  resource_group_name = azurerm_resource_group.this.name
}


resource "azurerm_federated_identity_credential" "dev_test" {
  name                = "dev-test"
  resource_group_name = local.resource_group_name
  parent_id           = azurerm_user_assigned_identity.dev_test.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.this.oidc_issuer_url
  subject             = "system:serviceaccount:dev:my-account"

  depends_on = [ azurerm_kubernetes_cluster.this ]
}
