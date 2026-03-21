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
  description = "Localização do Resource Group"
  value       = module.resource_group.location
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

output "acr_admin_username" {
  description = "Username admin do ACR"
  value       = module.acr.admin_username
  sensitive   = true
}

output "acr_admin_password" {
  description = "Password admin do ACR"
  value       = module.acr.admin_password
  sensitive   = true
}

# App Service Plan
output "app_service_plan_id" {
  description = "ID do App Service Plan"
  value       = module.webapp.app_service_plan_id
}

output "app_service_plan_name" {
  description = "Nome do App Service Plan"
  value       = module.webapp.app_service_plan_name
}

# Web App Catalog
output "webapp_catalog_id" {
  description = "ID do Web App fcg-catalog"
  value       = module.webapp.webapp_catalog_id
}

output "webapp_catalog_url" {
  description = "URL do Web App fcg-catalog"
  value       = module.webapp.webapp_catalog_url
}

output "webapp_catalog_default_hostname" {
  description = "Hostname padrão do Web App fcg-catalog"
  value       = module.webapp.webapp_catalog_default_hostname
}

# Web App Payments
output "webapp_payments_id" {
  description = "ID do Web App fcg-payments"
  value       = module.webapp.webapp_payments_id
}

output "webapp_payments_url" {
  description = "URL do Web App fcg-payments"
  value       = module.webapp.webapp_payments_url
}

output "webapp_payments_default_hostname" {
  description = "Hostname padrão do Web App fcg-payments"
  value       = module.webapp.webapp_payments_default_hostname
}

# Web App Users
output "webapp_users_id" {
  description = "ID do Web App fcg-users"
  value       = module.webapp.webapp_users_id
}

output "webapp_users_url" {
  description = "URL do Web App fcg-users"
  value       = module.webapp.webapp_users_url
}

output "webapp_users_default_hostname" {
  description = "Hostname padrão do Web App fcg-users"
  value       = module.webapp.webapp_users_default_hostname
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

output "sql_server_name" {
  description = "Nome do Azure SQL Server"
  value       = module.database.server_name
}

# SQL Databases
output "sql_database_catalog_id" {
  description = "ID do database fcg_catalog"
  value       = module.database.database_catalog_id
}

output "sql_database_catalog_name" {
  description = "Nome do database fcg_catalog"
  value       = module.database.database_catalog_name
}

output "sql_database_users_id" {
  description = "ID do database fcg_users"
  value       = module.database.database_users_id
}

output "sql_database_users_name" {
  description = "Nome do database fcg_users"
  value       = module.database.database_users_name
}

output "sql_database_payments_id" {
  description = "ID do database fcg_payments"
  value       = module.database.database_payments_id
}

output "sql_database_payments_name" {
  description = "Nome do database fcg_payments"
  value       = module.database.database_payments_name
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

output "apim_portal_url" {
  description = "URL do portal do desenvolvedor do API Management"
  value       = module.apim.portal_url
}

output "apim_management_url" {
  description = "URL do portal de gerenciamento do API Management"
  value       = module.apim.management_url
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

output "eventhub_namespace_connection_string" {
  description = "Connection string primária do Event Hub Namespace"
  value       = module.eventhub.namespace_connection_string
  sensitive   = true
}

output "eventhub_namespace_kafka_endpoint" {
  description = "Kafka endpoint do Event Hub Namespace"
  value       = module.eventhub.kafka_endpoint
}

output "eventhub_user_created_id" {
  description = "ID do Event Hub user-created"
  value       = module.eventhub.eventhub_user_created_id
}

output "eventhub_payment_processed_id" {
  description = "ID do Event Hub payment-processed"
  value       = module.eventhub.eventhub_payment_processed_id
}

output "eventhub_order_placed_id" {
  description = "ID do Event Hub order-placed"
  value       = module.eventhub.eventhub_order_placed_id
}