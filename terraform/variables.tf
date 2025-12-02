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

variable "sql_server_name" {
  description = "Nome do SQL Server (deve ser globalmente único)"
  type        = string
  default     = "fcg-user-sqlserver"
}

variable "sql_admin_login" {
  description = "Login do administrador do SQL Server"
  type        = string
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "Senha do administrador do SQL Server (deve ser fornecida via variável de ambiente ou prompt)"
  type        = string
  sensitive   = true
}

variable "sql_database_name" {
  description = "Nome do banco de dados SQL"
  type        = string
  default     = "fcg_user"
}

variable "sql_sku" {
  description = "SKU do SQL Database"
  type        = string
  default     = "Basic"
}

variable "sql_location" {
  description = "Localização do SQL Server na Azure"
  type        = string
  default     = "brazilsouth"
}
