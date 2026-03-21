output "server_id" {
  description = "ID do Azure SQL Server"
  value       = azurerm_mssql_server.main.id
}

output "server_fqdn" {
  description = "FQDN do Azure SQL Server"
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "server_name" {
  description = "Nome do Azure SQL Server"
  value       = azurerm_mssql_server.main.name
}

output "database_catalog_id" {
  description = "ID do database fcg_catalog"
  value       = azurerm_mssql_database.catalog.id
}

output "database_catalog_name" {
  description = "Nome do database fcg_catalog"
  value       = azurerm_mssql_database.catalog.name
}

output "database_users_id" {
  description = "ID do database fcg_users"
  value       = azurerm_mssql_database.users.id
}

output "database_users_name" {
  description = "Nome do database fcg_users"
  value       = azurerm_mssql_database.users.name
}

output "database_payments_id" {
  description = "ID do database fcg_payments"
  value       = azurerm_mssql_database.payments.id
}

output "database_payments_name" {
  description = "Nome do database fcg_payments"
  value       = azurerm_mssql_database.payments.name
}
