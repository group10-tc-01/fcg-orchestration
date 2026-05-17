variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
  default     = "fiap-fase-04"
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
    project     = "fiap-fase-04"
    managed_by  = "terraform"
  }
}

variable "acr_name" {
  description = "Nome do Azure Container Registry (deve ser globalmente único)"
  type        = string
  default     = "fcgacrfiap2026"
}

variable "acr_sku" {
  description = "SKU do Azure Container Registry"
  type        = string
  default     = "Basic"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "SKU deve ser Basic, Standard ou Premium."
  }
}

variable "acr_admin_enabled" {
  description = "Habilitar admin user no ACR"
  type        = bool
  default     = false
}

variable "docker_image_tag" {
  description = "Tag padrão das imagens Docker"
  type        = string
  default     = "latest"
}

variable "aks_cluster_name" {
  description = "Nome do cluster AKS"
  type        = string
  default     = "fcg-aks-fiap2026"
}

variable "aks_dns_prefix" {
  description = "Prefixo DNS do cluster AKS"
  type        = string
  default     = "fcg-aks-fiap2026"
}

variable "aks_node_count" {
  description = "Quantidade de nós do node pool padrão"
  type        = number
  default     = 1
}

variable "aks_node_vm_size" {
  description = "Tamanho da VM do node pool padrão"
  type        = string
  default     = "Standard_B2ms"
}

variable "aks_tier" {
  description = "Tier de gerenciamento do AKS"
  type        = string
  default     = "Free"
  validation {
    condition     = contains(["Free", "Standard", "Premium"], var.aks_tier)
    error_message = "aks_tier deve ser Free, Standard ou Premium."
  }
}

variable "aks_os_disk_size_gb" {
  description = "Tamanho do disco OS dos nós AKS em GB"
  type        = number
  default     = 64
}

variable "apim_backend_base_url" {
  description = "URL pública base do Ingress/Load Balancer do AKS usada como backend do APIM"
  type        = string
  default     = "https://example.com"
}

variable "functions_storage_account_name" {
  description = "Nome da Storage Account da Azure Function App (deve ser globalmente unico)"
  type        = string
  default     = "fcgfuncstfiap2026"
}

variable "functions_application_insights_name" {
  description = "Nome do Application Insights das Azure Functions"
  type        = string
  default     = "appi-fcg-functions-fiap2026"
}

variable "functions_service_plan_name" {
  description = "Nome do App Service Plan das Azure Functions"
  type        = string
  default     = "asp-fcg-functions"
}

variable "functions_service_plan_sku" {
  description = "SKU do App Service Plan das Azure Functions"
  type        = string
  default     = "Y1"
}

variable "function_app_name" {
  description = "Nome da Azure Function App (deve ser globalmente unico)"
  type        = string
  default     = "fcg-functions-fiap2026"
}

variable "functions_eventhub_consumer_group" {
  description = "Consumer group usado pelas Azure Functions"
  type        = string
  default     = "$Default"
}

variable "communication_service_name" {
  description = "Nome do Azure Communication Service (deve ser globalmente unico)"
  type        = string
  default     = "fcg-communication-fiap2026"
}

variable "communication_service_data_location" {
  description = "Data location do Azure Communication Service"
  type        = string
  default     = "United States"
}

variable "communication_service_sender_address" {
  description = "Endereco remetente validado no Azure Communication Services"
  type        = string
  default     = "DoNotReply@460e8bfe-e7e2-48f5-9393-a818043d2300.azurecomm.net"
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

# Key Vault variables
variable "key_vault_name" {
  description = "Nome do Azure Key Vault (deve ser globalmente único)"
  type        = string
  default     = "fcg-kv-fiap-2026"
}

variable "jwt_secret_key" {
  description = "Chave JWT injetada via Key Vault"
  type        = string
  sensitive   = true
}

variable "redis_connection_string" {
  description = "Connection string interna do Redis no AKS"
  type        = string
  default     = "redis-service.fcg-infra.svc.cluster.local:6379"
}

variable "mongodb_connection_string" {
  description = "Connection string interna do MongoDB no AKS"
  type        = string
  default     = "mongodb://mongodb-service.fcg-infra.svc.cluster.local:27017"
}

variable "elasticsearch_uri" {
  description = "URI interna do Elasticsearch no AKS"
  type        = string
  default     = "http://elasticsearch-service.fcg-infra.svc.cluster.local:9200"
}

# API Management variables
variable "apim_name" {
  description = "Nome do Azure API Management (deve ser globalmente único)"
  type        = string
  default     = "fcg-apim-fiap2026"
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
  default     = "eastus"
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
