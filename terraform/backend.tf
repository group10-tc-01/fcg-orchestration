terraform {
  backend "azurerm" {
    resource_group_name  = "fiap-fase-03"
    storage_account_name = "tfstatefcgfiap"
    container_name       = "tfstate"
    key                  = "fcg-orchestration.terraform.tfstate"
  }
}
