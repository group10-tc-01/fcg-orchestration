output "app_service_plan_id" {
  description = "ID do App Service Plan"
  value       = azurerm_service_plan.main.id
}

output "app_service_plan_name" {
  description = "Nome do App Service Plan"
  value       = azurerm_service_plan.main.name
}

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

# Managed Identity principal IDs para acesso ao Key Vault
output "webapp_principal_ids" {
  description = "Mapa de nome -> principal_id das Managed Identities dos Web Apps"
  value = {
    catalog  = azurerm_linux_web_app.catalog.identity[0].principal_id
    payments = azurerm_linux_web_app.payments.identity[0].principal_id
    users    = azurerm_linux_web_app.users.identity[0].principal_id
  }
}
