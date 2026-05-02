variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
}

variable "location" {
  description = "Localização do recurso"
  type        = string
}

variable "apim_name" {
  description = "Nome do Azure API Management (deve ser globalmente único)"
  type        = string
}

variable "apim_publisher_name" {
  description = "Nome da organização/publisher do API Management"
  type        = string
}

variable "apim_publisher_email" {
  description = "Email do administrador do API Management"
  type        = string
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

variable "backend_base_url" {
  description = "URL base publica do Ingress/Load Balancer do AKS."
  type        = string
}

variable "tags" {
  description = "Tags do recurso"
  type        = map(string)
  default     = {}
}
