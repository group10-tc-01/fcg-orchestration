output "key_vault_id" {
  description = "ID do Azure Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Nome do Azure Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI do Azure Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "secret_conn_catalog_uri" {
  description = "URI do secret sql-connection-catalog"
  value       = azurerm_key_vault_secret.sql_connection_catalog.versionless_id
}

output "secret_conn_users_uri" {
  description = "URI do secret sql-connection-users"
  value       = azurerm_key_vault_secret.sql_connection_users.versionless_id
}

output "secret_conn_payments_uri" {
  description = "URI do secret sql-connection-payments"
  value       = azurerm_key_vault_secret.sql_connection_payments.versionless_id
}

output "secret_eventhub_connection_uri" {
  description = "URI do secret eventhub-connection"
  value       = azurerm_key_vault_secret.eventhub_connection.versionless_id
}

output "secret_communication_connection_uri" {
  description = "URI do secret communication-connection"
  value       = azurerm_key_vault_secret.communication_connection.versionless_id
}

output "secret_jwt_secret_key_uri" {
  description = "URI do secret jwt-secret-key"
  value       = azurerm_key_vault_secret.jwt_secret_key.versionless_id
}

output "secret_redis_connection_uri" {
  description = "URI do secret redis-connection"
  value       = azurerm_key_vault_secret.redis_connection.versionless_id
}

output "secret_mongodb_connection_uri" {
  description = "URI do secret mongodb-connection"
  value       = azurerm_key_vault_secret.mongodb_connection.versionless_id
}

output "secret_elasticsearch_uri" {
  description = "URI do secret elasticsearch-uri"
  value       = azurerm_key_vault_secret.elasticsearch_uri.versionless_id
}
