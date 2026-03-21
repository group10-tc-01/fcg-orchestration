output "namespace_id" {
  description = "ID do Event Hub Namespace"
  value       = azurerm_eventhub_namespace.main.id
}

output "namespace_name" {
  description = "Nome do Event Hub Namespace"
  value       = azurerm_eventhub_namespace.main.name
}

output "namespace_connection_string" {
  description = "Connection string primária do Event Hub Namespace"
  value       = azurerm_eventhub_namespace.main.default_primary_connection_string
  sensitive   = true
}

output "kafka_endpoint" {
  description = "Kafka endpoint do Event Hub Namespace"
  value       = "${azurerm_eventhub_namespace.main.name}.servicebus.windows.net:9093"
}

output "eventhub_user_created_id" {
  description = "ID do Event Hub user-created"
  value       = azurerm_eventhub.user_created.id
}

output "eventhub_user_created_name" {
  description = "Nome do Event Hub user-created"
  value       = azurerm_eventhub.user_created.name
}

output "eventhub_payment_processed_id" {
  description = "ID do Event Hub payment-processed"
  value       = azurerm_eventhub.payment_processed.id
}

output "eventhub_order_placed_id" {
  description = "ID do Event Hub order-placed"
  value       = azurerm_eventhub.order_placed.id
}
