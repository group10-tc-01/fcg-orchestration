variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
}

variable "location" {
  description = "Localização do Resource Group na Azure"
  type        = string
}

variable "tags" {
  description = "Tags para o Resource Group"
  type        = map(string)
  default     = {}
}
