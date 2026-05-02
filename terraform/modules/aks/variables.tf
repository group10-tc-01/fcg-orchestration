variable "aks_cluster_name" {
  description = "Nome do cluster AKS."
  type        = string
}

variable "resource_group_name" {
  description = "Nome do Resource Group."
  type        = string
}

variable "location" {
  description = "Localizacao do cluster AKS."
  type        = string
}

variable "aks_dns_prefix" {
  description = "Prefixo DNS do cluster AKS."
  type        = string
}

variable "kubernetes_version" {
  description = "Versao do Kubernetes. Null usa a versao padrao suportada pela Azure."
  type        = string
  default     = null
}

variable "aks_tier" {
  description = "Tier de gerenciamento do AKS."
  type        = string
  default     = "Free"
  validation {
    condition     = contains(["Free", "Standard", "Premium"], var.aks_tier)
    error_message = "aks_tier deve ser Free, Standard ou Premium."
  }
}

variable "aks_node_count" {
  description = "Quantidade de nos do node pool padrao."
  type        = number
  default     = 1
}

variable "aks_node_vm_size" {
  description = "Tamanho da VM do node pool padrao."
  type        = string
  default     = "Standard_B2ms"
}

variable "aks_os_disk_size_gb" {
  description = "Tamanho do disco OS dos nos AKS em GB."
  type        = number
  default     = 64
}

variable "acr_id" {
  description = "ID do Azure Container Registry para permissao AcrPull."
  type        = string
}

variable "tags" {
  description = "Tags dos recursos."
  type        = map(string)
  default     = {}
}
