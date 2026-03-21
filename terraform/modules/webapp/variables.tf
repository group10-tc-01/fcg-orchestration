variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
}

variable "location" {
  description = "Localização do recurso"
  type        = string
}

variable "app_service_plan_name" {
  description = "Nome do App Service Plan compartilhado"
  type        = string
}

variable "app_service_plan_sku" {
  description = "SKU do App Service Plan"
  type        = string
  default     = "B1"
  validation {
    condition     = contains(["F1", "D1", "B1", "B2", "B3", "S1", "S2", "S3", "P1v2", "P2v2", "P3v2"], var.app_service_plan_sku)
    error_message = "SKU deve ser um valor válido de App Service Plan."
  }
}

variable "webapp_catalog_name" {
  description = "Nome do Web App para o microsserviço fcg-catalog"
  type        = string
}

variable "webapp_payments_name" {
  description = "Nome do Web App para o microsserviço fcg-payments"
  type        = string
}

variable "webapp_users_name" {
  description = "Nome do Web App para o microsserviço fcg-users"
  type        = string
}

variable "docker_image_tag" {
  description = "Tag padrão das imagens Docker"
  type        = string
  default     = "latest"
}

# ACR inputs
variable "acr_login_server" {
  description = "Login server do Azure Container Registry"
  type        = string
}

variable "acr_admin_username" {
  description = "Username admin do ACR"
  type        = string
  sensitive   = true
}

variable "acr_admin_password" {
  description = "Password admin do ACR"
  type        = string
  sensitive   = true
}

# Database inputs
variable "sql_server_fqdn" {
  description = "FQDN do Azure SQL Server"
  type        = string
}

variable "sql_admin_username" {
  description = "Username do administrador do SQL Server"
  type        = string
}

variable "sql_admin_password" {
  description = "Senha do administrador do SQL Server"
  type        = string
  sensitive   = true
}

variable "sql_database_catalog_name" {
  description = "Nome do database fcg_catalog"
  type        = string
}

variable "sql_database_users_name" {
  description = "Nome do database fcg_users"
  type        = string
}

variable "sql_database_payments_name" {
  description = "Nome do database fcg_payments"
  type        = string
}

# Monitoring inputs
variable "app_insights_instrumentation_key" {
  description = "Instrumentation Key do Application Insights"
  type        = string
  sensitive   = true
}

variable "app_insights_connection_string" {
  description = "Connection String do Application Insights"
  type        = string
  sensitive   = true
}

# Event Hub inputs
variable "eventhub_kafka_endpoint" {
  description = "Kafka endpoint do Event Hub Namespace"
  type        = string
}

variable "eventhub_connection_string" {
  description = "Connection string do Event Hub Namespace"
  type        = string
  sensitive   = true
}

variable "eventhub_user_created_name" {
  description = "Nome do Event Hub user-created"
  type        = string
}

variable "tags" {
  description = "Tags do recurso"
  type        = map(string)
  default     = {}
}
