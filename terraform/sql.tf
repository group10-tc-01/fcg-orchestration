resource "azurerm_mssql_server" "sql" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.main.name
  location                     = var.sql_location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"

  tags = var.tags
}

resource "azurerm_mssql_database" "db" {
  name           = var.sql_database_name
  server_id      = azurerm_mssql_server.sql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 2
  sku_name       = var.sql_sku
  zone_redundant = false

  tags = var.tags
}

# Permitir acesso de serviços Azure
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Permitir acesso de qualquer IP (somente para teste)
resource "azurerm_mssql_firewall_rule" "allow_all" {
  name             = "AllowAll"
  server_id        = azurerm_mssql_server.sql.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}
