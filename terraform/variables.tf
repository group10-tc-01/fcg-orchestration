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

