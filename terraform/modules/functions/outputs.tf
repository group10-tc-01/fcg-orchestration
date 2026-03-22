output "storage_account_id" {
  description = "ID da Storage Account das Functions"
  value       = azurerm_storage_account.main.id
}

output "storage_account_name" {
  description = "Nome da Storage Account das Functions"
  value       = azurerm_storage_account.main.name
}

output "application_insights_id" {
  description = "ID do Application Insights das Functions"
  value       = azurerm_application_insights.main.id
}

output "application_insights_name" {
  description = "Nome do Application Insights das Functions"
  value       = azurerm_application_insights.main.name
}

output "application_insights_connection_string" {
  description = "Connection string do Application Insights das Functions"
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
}

output "service_plan_id" {
  description = "ID do App Service Plan das Functions"
  value       = azurerm_service_plan.main.id
}

output "service_plan_name" {
  description = "Nome do App Service Plan das Functions"
  value       = azurerm_service_plan.main.name
}

output "function_app_id" {
  description = "ID da Azure Function App"
  value       = azurerm_linux_function_app.main.id
}

output "function_app_name" {
  description = "Nome da Azure Function App"
  value       = azurerm_linux_function_app.main.name
}

output "function_app_default_hostname" {
  description = "Hostname padrao da Azure Function App"
  value       = azurerm_linux_function_app.main.default_hostname
}

output "function_app_url" {
  description = "URL da Azure Function App"
  value       = "https://${azurerm_linux_function_app.main.default_hostname}"
}

output "function_app_principal_id" {
  description = "Principal ID da Managed Identity da Azure Function App"
  value       = azurerm_linux_function_app.main.identity[0].principal_id
}
