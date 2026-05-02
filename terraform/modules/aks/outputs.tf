output "aks_id" {
  description = "ID do cluster AKS."
  value       = azurerm_kubernetes_cluster.main.id
}

output "aks_name" {
  description = "Nome do cluster AKS."
  value       = azurerm_kubernetes_cluster.main.name
}

output "aks_fqdn" {
  description = "FQDN do cluster AKS."
  value       = azurerm_kubernetes_cluster.main.fqdn
}

output "kubelet_identity_object_id" {
  description = "Object ID da kubelet identity do AKS."
  value       = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

output "key_vault_secrets_provider_object_id" {
  description = "Object ID da identidade usada pelo Key Vault Secrets Provider."
  value       = azurerm_kubernetes_cluster.main.key_vault_secrets_provider[0].secret_identity[0].object_id
}

output "key_vault_secrets_provider_client_id" {
  description = "Client ID da identidade usada pelo Key Vault Secrets Provider."
  value       = azurerm_kubernetes_cluster.main.key_vault_secrets_provider[0].secret_identity[0].client_id
}
