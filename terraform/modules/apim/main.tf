resource "azurerm_api_management" "main" {
  name                = var.apim_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.apim_publisher_name
  publisher_email     = var.apim_publisher_email
  sku_name            = var.apim_sku_name
  tags                = var.tags

  public_network_access_enabled = true
}

locals {
  apis = {
    users = {
      display_name = "FCG Users API"
      path         = "api/v1/users"
      service_url  = "${var.backend_base_url}/api/v1/users"
    }
    catalog = {
      display_name = "FCG Catalog API"
      path         = "api/v1/games"
      service_url  = "${var.backend_base_url}/api/v1/games"
    }
    payments = {
      display_name = "FCG Payments API"
      path         = "api/v1/payments"
      service_url  = "${var.backend_base_url}/api/v1/payments"
    }
  }
}

resource "azurerm_api_management_api" "apis" {
  for_each            = local.apis
  name                = "fcg-${each.key}"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = each.value.display_name
  path                = each.value.path
  protocols           = ["https"]
  service_url         = each.value.service_url
}
