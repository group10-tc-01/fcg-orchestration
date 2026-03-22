variable "communication_service_name" {
  description = "Nome do Azure Communication Service"
  type        = string
}

variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
}

variable "data_location" {
  description = "Data location do Azure Communication Service"
  type        = string
  default     = "United States"
}

variable "tags" {
  description = "Tags do recurso"
  type        = map(string)
  default     = {}
}
