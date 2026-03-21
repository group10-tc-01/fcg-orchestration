output "id" {
  description = "ID do Resource Group"
  value       = azurerm_resource_group.main.id
}

output "name" {
  description = "Nome do Resource Group"
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "Localização do Resource Group"
  value       = azurerm_resource_group.main.location
}
