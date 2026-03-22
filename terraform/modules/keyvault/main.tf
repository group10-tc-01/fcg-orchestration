# Busca o tenant ID da subscription atual
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  tags                       = var.tags

  # Permite que o Terraform (identidade que está rodando o apply) gerencie secrets
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge", "Recover"
    ]
  }
}

# Access policies para os Web Apps (Managed Identity)
resource "azurerm_key_vault_access_policy" "webapp" {
  for_each     = var.webapp_principal_ids
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.value

  secret_permissions = ["Get", "List"]
}

# Connection Strings
resource "azurerm_key_vault_secret" "sql_connection_catalog" {
  name         = "sql-connection-catalog"
  value        = "Server=${var.sql_server_fqdn};Database=${var.sql_database_catalog_name};User Id=${var.sql_admin_username};Password=${var.sql_admin_password};TrustServerCertificate=True;"
  key_vault_id = azurerm_key_vault.main.id
  tags         = var.tags
}

resource "azurerm_key_vault_secret" "sql_connection_users" {
  name         = "sql-connection-users"
  value        = "Server=${var.sql_server_fqdn};Database=${var.sql_database_users_name};User Id=${var.sql_admin_username};Password=${var.sql_admin_password};TrustServerCertificate=True;"
  key_vault_id = azurerm_key_vault.main.id
  tags         = var.tags
}

resource "azurerm_key_vault_secret" "sql_connection_payments" {
  name         = "sql-connection-payments"
  value        = "Server=${var.sql_server_fqdn};Database=${var.sql_database_payments_name};User Id=${var.sql_admin_username};Password=${var.sql_admin_password};TrustServerCertificate=True;"
  key_vault_id = azurerm_key_vault.main.id
  tags         = var.tags
}
