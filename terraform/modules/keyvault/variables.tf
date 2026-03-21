variable "key_vault_name" {
  description = "Nome do Azure Key Vault (deve ser globalmente único)"
  type        = string
}

variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
}

variable "location" {
  description = "Localização do recurso"
  type        = string
}

variable "tags" {
  description = "Tags do recurso"
  type        = map(string)
  default     = {}
}

# Web Apps Managed Identity principal IDs para acesso ao Key Vault
variable "webapp_principal_ids" {
  description = "Mapa de nome -> principal_id das Managed Identities dos Web Apps"
  type        = map(string)
  default     = {}
}

# Database inputs para montar as connection strings
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
