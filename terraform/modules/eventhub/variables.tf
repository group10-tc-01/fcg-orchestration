variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
}

variable "eventhub_namespace_name" {
  description = "Nome do Event Hub Namespace (deve ser globalmente único)"
  type        = string
}

variable "eventhub_location" {
  description = "Localização do Event Hub Namespace"
  type        = string
}

variable "eventhub_namespace_sku" {
  description = "SKU do Event Hub Namespace"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.eventhub_namespace_sku)
    error_message = "SKU deve ser Basic, Standard ou Premium."
  }
}

variable "eventhub_namespace_capacity" {
  description = "Capacidade do Event Hub Namespace (Throughput Units)"
  type        = number
  default     = 1
  validation {
    condition     = var.eventhub_namespace_capacity >= 1 && var.eventhub_namespace_capacity <= 20
    error_message = "Capacidade deve estar entre 1 e 20."
  }
}

variable "eventhub_user_created_name" {
  description = "Nome do Event Hub para eventos de usuários criados"
  type        = string
  default     = "user-created"
}

variable "eventhub_payment_processed_name" {
  description = "Nome do Event Hub para eventos de pagamentos processados"
  type        = string
  default     = "payment-processed"
}

variable "eventhub_order_placed_name" {
  description = "Nome do Event Hub para eventos de pedidos criados"
  type        = string
  default     = "order-placed"
}

variable "eventhub_partition_count" {
  description = "Número de partições dos Event Hubs"
  type        = number
  default     = 1
  validation {
    condition     = var.eventhub_partition_count >= 1 && var.eventhub_partition_count <= 32
    error_message = "Partition count deve estar entre 1 e 32."
  }
}

variable "eventhub_message_retention" {
  description = "Dias de retenção de mensagens dos Event Hubs"
  type        = number
  default     = 1
  validation {
    condition     = var.eventhub_message_retention >= 1 && var.eventhub_message_retention <= 7
    error_message = "Message retention deve estar entre 1 e 7 dias para SKU Standard."
  }
}

variable "tags" {
  description = "Tags do recurso"
  type        = map(string)
  default     = {}
}
