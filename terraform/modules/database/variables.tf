variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
}

variable "sql_location" {
  description = "Localização específica para o SQL Server"
  type        = string
}

variable "sql_server_name" {
  description = "Nome do Azure SQL Server (deve ser globalmente único)"
  type        = string
}

variable "sql_server_version" {
  description = "Versão do SQL Server"
  type        = string
  default     = "12.0"
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

variable "tags" {
  description = "Tags do recurso"
  type        = map(string)
  default     = {}
}
