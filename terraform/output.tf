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

# App Service Plan outputs
output "app_service_plan_id" {
  description = "ID do App Service Plan"
  value       = azurerm_service_plan.main.id
}

output "app_service_plan_name" {
  description = "Nome do App Service Plan"
  value       = azurerm_service_plan.main.name
}

# Web App Catalog outputs
output "webapp_catalog_id" {
  description = "ID do Web App fcg-catalog"
  value       = azurerm_linux_web_app.catalog.id
}

output "webapp_catalog_url" {
  description = "URL do Web App fcg-catalog"
  value       = "https://${azurerm_linux_web_app.catalog.default_hostname}"
}

output "webapp_catalog_default_hostname" {
  description = "Hostname padrão do Web App fcg-catalog"
  value       = azurerm_linux_web_app.catalog.default_hostname
}

# Web App Payments outputs
output "webapp_payments_id" {
  description = "ID do Web App fcg-payments"
  value       = azurerm_linux_web_app.payments.id
}

output "webapp_payments_url" {
  description = "URL do Web App fcg-payments"
  value       = "https://${azurerm_linux_web_app.payments.default_hostname}"
}

output "webapp_payments_default_hostname" {
  description = "Hostname padrão do Web App fcg-payments"
  value       = azurerm_linux_web_app.payments.default_hostname
}

# Web App Users outputs
output "webapp_users_id" {
  description = "ID do Web App fcg-users"
  value       = azurerm_linux_web_app.users.id
}

output "webapp_users_url" {
  description = "URL do Web App fcg-users"
  value       = "https://${azurerm_linux_web_app.users.default_hostname}"
}

output "webapp_users_default_hostname" {
  description = "Hostname padrão do Web App fcg-users"
  value       = azurerm_linux_web_app.users.default_hostname
}

# SQL Server outputs
output "sql_server_id" {
  description = "ID do Azure SQL Server"
  value       = azurerm_mssql_server.main.id
}

output "sql_server_fqdn" {
  description = "FQDN do Azure SQL Server"
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "sql_server_name" {
  description = "Nome do Azure SQL Server"
  value       = azurerm_mssql_server.main.name
}

# SQL Database outputs
output "sql_database_catalog_id" {
  description = "ID do database fcg_catalog"
  value       = azurerm_mssql_database.catalog.id
}

output "sql_database_catalog_name" {
  description = "Nome do database fcg_catalog"
  value       = azurerm_mssql_database.catalog.name
}

output "sql_database_users_id" {
  description = "ID do database fcg_users"
  value       = azurerm_mssql_database.users.id
}

output "sql_database_users_name" {
  description = "Nome do database fcg_users"
  value       = azurerm_mssql_database.users.name
}

output "sql_database_payments_id" {
  description = "ID do database fcg_payments"
  value       = azurerm_mssql_database.payments.id
}

output "sql_database_payments_name" {
  description = "Nome do database fcg_payments"
  value       = azurerm_mssql_database.payments.name
}

# Connection Strings (sensitive)
output "connection_string_catalog" {
  description = "Connection string para o database fcg_catalog"
  value       = "Server=${azurerm_mssql_server.main.fully_qualified_domain_name};Database=${azurerm_mssql_database.catalog.name};User Id=${var.sql_admin_username};Password=${var.sql_admin_password};TrustServerCertificate=True;"
  sensitive   = true
}

output "connection_string_users" {
  description = "Connection string para o database fcg_users"
  value       = "Server=${azurerm_mssql_server.main.fully_qualified_domain_name};Database=${azurerm_mssql_database.users.name};User Id=${var.sql_admin_username};Password=${var.sql_admin_password};TrustServerCertificate=True;"
  sensitive   = true
}

output "connection_string_payments" {
  description = "Connection string para o database fcg_payments"
  value       = "Server=${azurerm_mssql_server.main.fully_qualified_domain_name};Database=${azurerm_mssql_database.payments.name};User Id=${var.sql_admin_username};Password=${var.sql_admin_password};TrustServerCertificate=True;"
  sensitive   = true
}
