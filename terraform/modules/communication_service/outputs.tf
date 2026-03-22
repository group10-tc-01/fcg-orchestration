output "id" {
  description = "ID do Azure Communication Service"
  value       = azurerm_communication_service.main.id
}

output "name" {
  description = "Nome do Azure Communication Service"
  value       = azurerm_communication_service.main.name
}

output "primary_connection_string" {
  description = "Primary connection string do Azure Communication Service"
  value       = azurerm_communication_service.main.primary_connection_string
  sensitive   = true
}

output "primary_key" {
  description = "Primary key do Azure Communication Service"
  value       = azurerm_communication_service.main.primary_key
  sensitive   = true
}
