# Resource Group
output "resource_group_id" {
  description = "ID do Resource Group"
  value       = module.resource_group.id
}

output "resource_group_name" {
  description = "Nome do Resource Group"
  value       = module.resource_group.name
}

output "resource_group_location" {
  description = "Localizacao do Resource Group"
  value       = module.resource_group.location
}

# AKS
output "aks_id" {
  description = "ID do cluster AKS"
  value       = module.aks.aks_id
}

output "aks_name" {
  description = "Nome do cluster AKS"
  value       = module.aks.aks_name
}

output "aks_fqdn" {
  description = "FQDN do cluster AKS"
  value       = module.aks.aks_fqdn
}

output "aks_kubelet_identity_object_id" {
  description = "Object ID da kubelet identity do AKS"
  value       = module.aks.kubelet_identity_object_id
}

output "aks_key_vault_secrets_provider_object_id" {
  description = "Object ID da identidade do Key Vault Secrets Provider"
  value       = module.aks.key_vault_secrets_provider_object_id
}

output "aks_key_vault_secrets_provider_client_id" {
  description = "Client ID da identidade do Key Vault Secrets Provider"
  value       = module.aks.key_vault_secrets_provider_client_id
}

# ACR
output "acr_id" {
  description = "ID do Azure Container Registry"
  value       = module.acr.id
}

output "acr_login_server" {
  description = "URL do login server do ACR"
  value       = module.acr.login_server
}

# Azure Functions
output "function_app_id" {
  description = "ID da Azure Function App"
  value       = module.functions.function_app_id
}

output "function_app_name" {
  description = "Nome da Azure Function App"
  value       = module.functions.function_app_name
}

output "function_app_url" {
  description = "URL da Azure Function App"
  value       = module.functions.function_app_url
}

# Azure Communication Service
output "communication_service_id" {
  description = "ID do Azure Communication Service"
  value       = module.communication_service.id
}

output "communication_service_name" {
  description = "Nome do Azure Communication Service"
  value       = module.communication_service.name
}

# SQL Server
output "sql_server_id" {
  description = "ID do Azure SQL Server"
  value       = module.database.server_id
}

output "sql_server_fqdn" {
  description = "FQDN do Azure SQL Server"
  value       = module.database.server_fqdn
}

output "sql_database_names" {
  description = "Nomes dos databases SQL"
  value = {
    catalog  = module.database.database_catalog_name
    users    = module.database.database_users_name
    payments = module.database.database_payments_name
  }
}

# Key Vault
output "key_vault_id" {
  description = "ID do Azure Key Vault"
  value       = module.keyvault.key_vault_id
}

output "key_vault_name" {
  description = "Nome do Azure Key Vault"
  value       = module.keyvault.key_vault_name
}

output "key_vault_uri" {
  description = "URI do Azure Key Vault"
  value       = module.keyvault.key_vault_uri
}

# API Management
output "apim_id" {
  description = "ID do Azure API Management"
  value       = module.apim.id
}

output "apim_name" {
  description = "Nome do Azure API Management"
  value       = module.apim.name
}

output "apim_gateway_url" {
  description = "URL do gateway do API Management"
  value       = module.apim.gateway_url
}

output "apim_api_paths" {
  description = "Paths publicados no API Management"
  value       = module.apim.api_paths
}

# Event Hub
output "eventhub_namespace_id" {
  description = "ID do Event Hub Namespace"
  value       = module.eventhub.namespace_id
}

output "eventhub_namespace_name" {
  description = "Nome do Event Hub Namespace"
  value       = module.eventhub.namespace_name
}

output "eventhub_namespace_kafka_endpoint" {
  description = "Kafka endpoint do Event Hub Namespace"
  value       = module.eventhub.kafka_endpoint
}
