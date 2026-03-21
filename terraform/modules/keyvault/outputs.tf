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
