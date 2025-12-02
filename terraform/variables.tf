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
