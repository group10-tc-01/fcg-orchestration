output "resource_group_id" {
  description = "ID do Resource Group"
  value       = azurerm_resource_group.main.id
}

output "resource_group_name" {
  description = "Nome do Resource Group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Localização do Resource Group"
  value       = azurerm_resource_group.main.location
}

output "acr_id" {
  description = "ID do Azure Container Registry"
  value       = azurerm_container_registry.acr.id
}

output "acr_login_server" {
  description = "URL do login server do ACR"
  value       = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  description = "Username admin do ACR"
  value       = azurerm_container_registry.acr.admin_username
  sensitive   = true
}

output "acr_admin_password" {
  description = "Password admin do ACR"
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
}

output "sql_server_fqdn" {
  description = "FQDN do SQL Server"
  value       = azurerm_mssql_server.sql.fully_qualified_domain_name
}

output "sql_database_name" {
  description = "Nome do banco de dados SQL"
  value       = azurerm_mssql_database.db.name
}

output "sql_connection_string" {
  description = "Connection string do SQL Database"
  value       = "Server=${azurerm_mssql_server.sql.fully_qualified_domain_name};Database=${azurerm_mssql_database.db.name};User Id=${var.sql_admin_login};Password=${var.sql_admin_password};TrustServerCertificate=True;"
  sensitive   = true
}
