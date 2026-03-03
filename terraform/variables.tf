variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
  default     = "fiap-fase-02"
}

variable "location" {
  description = "Localização do Resource Group na Azure"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Tags para o Resource Group"
  type        = map(string)
  default = {
    environment = "dev"
    project     = "fiap-fase-02"
    managed_by  = "terraform"
  }
}

variable "acr_name" {
  description = "Nome do Azure Container Registry (deve ser globalmente único)"
  type        = string
  default     = "fiapcr"
}

variable "acr_sku" {
  description = "SKU do Azure Container Registry"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "SKU deve ser Basic, Standard ou Premium."
  }
}

variable "acr_admin_enabled" {
  description = "Habilitar admin user no ACR"
  type        = bool
  default     = true
}

variable "app_service_plan_name" {
  description = "Nome do App Service Plan compartilhado"
  type        = string
  default     = "asp-fcg-microservices"
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
  default     = "fcg-catalog"
}

variable "webapp_payments_name" {
  description = "Nome do Web App para o microsserviço fcg-payments"
  type        = string
  default     = "fcg-payments"
}

variable "webapp_users_name" {
  description = "Nome do Web App para o microsserviço fcg-users"
  type        = string
  default     = "fcg-users"
}

variable "docker_image_tag" {
  description = "Tag padrão das imagens Docker"
  type        = string
  default     = "latest"
}

# SQL Server variables
variable "sql_location" {
  description = "Localização específica para o SQL Server (pode ser diferente do Resource Group)"
  type        = string
  default     = "brazilsouth"
}

variable "sql_server_name" {
  description = "Nome do Azure SQL Server (deve ser globalmente único)"
  type        = string
  default     = "fcg-sql-fiap-2026"
}

variable "sql_server_version" {
  description = "Versão do SQL Server"
  type        = string
  default     = "12.0"
}

variable "sql_admin_username" {
  description = "Username do administrador do SQL Server"
  type        = string
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "Senha do administrador do SQL Server"
  type        = string
  sensitive   = true
}

variable "sql_database_sku" {
  description = "SKU dos SQL Databases"
  type        = string
  default     = "Basic"
  validation {
    condition     = contains(["Basic", "S0", "S1", "S2", "S3", "P1", "P2", "P4"], var.sql_database_sku)
    error_message = "SKU deve ser um valor válido de SQL Database."
  }
}

variable "sql_allowed_ips" {
  description = "Mapa de IPs permitidos para acessar o SQL Server (nome -> IP)"
  type        = map(string)
  default     = {}
}

# API Management variables
variable "apim_name" {
  description = "Nome do Azure API Management (deve ser globalmente único)"
  type        = string
  default     = "fcg-apim-fiap-2026"
}

variable "apim_publisher_name" {
  description = "Nome da organização/publisher do API Management"
  type        = string
  default     = "FIAP FCG"
}

variable "apim_publisher_email" {
  description = "Email do administrador do API Management"
  type        = string
  default     = "flaviojcostafilho@gmail.com"
}

variable "apim_sku_name" {
  description = "SKU do API Management"
  type        = string
  default     = "Developer_1"
  validation {
    condition     = contains(["Consumption_0", "Developer_1", "Basic_1", "Basic_2", "Standard_1", "Standard_2", "Premium_1"], var.apim_sku_name)
    error_message = "SKU deve ser um valor válido de API Management."
  }
}

# Event Hub Namespace variables
variable "eventhub_namespace_name" {
  description = "Nome do Event Hub Namespace (deve ser globalmente único)"
  type        = string
  default     = "fcg-kafka"
}

variable "eventhub_location" {
  description = "Localização do Event Hub Namespace"
  type        = string
  default     = "brazilsouth"
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

# Event Hub topics variables
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

# Application Insights variables
variable "app_insights_users_name" {
  description = "Nome do Application Insights para o microsserviço Users"
  type        = string
  default     = "fcg-users"
}

variable "app_insights_retention_days" {
  description = "Dias de retenção do Application Insights"
  type        = number
  default     = 90
  validation {
    condition     = contains([30, 60, 90, 120, 180, 270, 365, 550, 730], var.app_insights_retention_days)
    error_message = "Retention deve ser um dos valores válidos: 30, 60, 90, 120, 180, 270, 365, 550, 730."
  }
}

variable "app_insights_workspace_id" {
  description = "ID do Log Analytics Workspace para Application Insights"
  type        = string
  default     = "/subscriptions/d4af460f-e431-42e5-884c-d0811f48cf99/resourceGroups/DefaultResourceGroup-EUS/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-d4af460f-e431-42e5-884c-d0811f48cf99-EUS"
}

