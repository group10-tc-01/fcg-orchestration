variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
}

variable "location" {
  description = "Localizacao do recurso"
  type        = string
}

variable "storage_account_name" {
  description = "Nome da Storage Account da Function App"
  type        = string
}

variable "storage_account_tier" {
  description = "Tier da Storage Account"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "Replicacao da Storage Account"
  type        = string
  default     = "LRS"
}

variable "application_insights_name" {
  description = "Nome do Application Insights das Functions"
  type        = string
}

variable "service_plan_name" {
  description = "Nome do App Service Plan das Functions"
  type        = string
}

variable "service_plan_sku" {
  description = "SKU do App Service Plan das Functions"
  type        = string
  default     = "B1"
}

variable "function_app_name" {
  description = "Nome do Azure Function App"
  type        = string
}

variable "eventhub_connection_string" {
  description = "Connection string do Event Hub Namespace"
  type        = string
  sensitive   = true
}

variable "eventhub_consumer_group" {
  description = "Consumer group usado pelas Functions"
  type        = string
  default     = "$Default"
}

variable "eventhub_user_created_name" {
  description = "Nome do Event Hub user-created"
  type        = string
}

variable "eventhub_payment_processed_name" {
  description = "Nome do Event Hub payment-processed"
  type        = string
}

variable "email_connection_string" {
  description = "Connection string do Azure Communication Services"
  type        = string
  sensitive   = true
  default     = null
}

variable "email_sender_address" {
  description = "Endereco remetente validado no Azure Communication Services"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags do recurso"
  type        = map(string)
  default     = {}
}
