output "id" {
  description = "ID do Azure API Management"
  value       = azurerm_api_management.main.id
}

output "name" {
  description = "Nome do Azure API Management"
  value       = azurerm_api_management.main.name
}

output "gateway_url" {
  description = "URL do gateway do API Management"
  value       = azurerm_api_management.main.gateway_url
}

output "portal_url" {
  description = "URL do portal do desenvolvedor do API Management"
  value       = azurerm_api_management.main.developer_portal_url
}

output "management_url" {
  description = "URL do portal de gerenciamento do API Management"
  value       = azurerm_api_management.main.management_api_url
}
