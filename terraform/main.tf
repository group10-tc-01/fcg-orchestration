resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_container_registry" "acr" {
  name                          = var.acr_name
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  sku                           = var.acr_sku
  admin_enabled                 = var.acr_admin_enabled
  tags                          = var.tags
  public_network_access_enabled = true
  anonymous_pull_enabled        = true
}

resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku
  tags                = var.tags
}

resource "azurerm_linux_web_app" "catalog" {
  name                = var.webapp_catalog_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true
  tags                = var.tags

  site_config {
    always_on = true
    application_stack {
      docker_image_name   = "${azurerm_container_registry.acr.login_server}/fcg-catalog:${var.docker_image_tag}"
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
    }
  }

  app_settings = {
    # Docker Registry
    "DOCKER_REGISTRY_SERVER_URL"           = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME"      = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"      = azurerm_container_registry.acr.admin_password
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE"  = "false"
    
    # Container Port Configuration
    "WEBSITES_PORT"                        = "8080"
    "ASPNETCORE_ENVIRONMENT"               = "Production"
    
    # Database Connection String
    "ConnectionStrings__DefaultConnection" = "Server=${azurerm_mssql_server.main.fully_qualified_domain_name};Database=${azurerm_mssql_database.catalog.name};User Id=${var.sql_admin_username};Password=${var.sql_admin_password};TrustServerCertificate=True;"
    
    # JWT Settings
    "JwtSettings__SecretKey"                    = "z3F+7sR8vN5YlG1aXb2j8KqH0yL9uD3vM4pQ5rT6sU8="
    "JwtSettings__Issuer"                       = "FCG-Catalog"
    "JwtSettings__Audience"                     = "FCG-Client"
    "JwtSettings__AccessTokenExpirationMinutes" = "60"
    "JwtSettings__RefreshTokenExpirationDays"   = "7"
  }
}

resource "azurerm_linux_web_app" "payments" {
  name                = var.webapp_payments_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true
  tags                = var.tags

  site_config {
    always_on = true
    application_stack {
      docker_image_name   = "${azurerm_container_registry.acr.login_server}/fcg-payments:${var.docker_image_tag}"
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
    }
  }

  app_settings = {
    # Docker Registry
    "DOCKER_REGISTRY_SERVER_URL"           = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME"      = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"      = azurerm_container_registry.acr.admin_password
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE"  = "false"
    
    # Container Port Configuration
    "WEBSITES_PORT"                        = "8080"
    "ASPNETCORE_ENVIRONMENT"               = "Production"
    
    # Database Connection String
    "ConnectionStrings__DefaultConnection" = "Server=${azurerm_mssql_server.main.fully_qualified_domain_name};Database=${azurerm_mssql_database.payments.name};User Id=${var.sql_admin_username};Password=${var.sql_admin_password};TrustServerCertificate=True;"
    
    # JWT Settings
    "JwtSettings__SecretKey"                    = "z3F+7sR8vN5YlG1aXb2j8KqH0yL9uD3vM4pQ5rT6sU8="
    "JwtSettings__Issuer"                       = "FCG-Payments"
    "JwtSettings__Audience"                     = "FCG-Client"
    "JwtSettings__AccessTokenExpirationMinutes" = "60"
    "JwtSettings__RefreshTokenExpirationDays"   = "7"
  }
}

resource "azurerm_linux_web_app" "users" {
  name                = var.webapp_users_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true
  tags                = var.tags

  site_config {
    always_on = true
    application_stack {
      docker_image_name   = "${azurerm_container_registry.acr.login_server}/fcg-users:${var.docker_image_tag}"
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
    }
  }

  app_settings = {
    # Docker Registry
    "DOCKER_REGISTRY_SERVER_URL"           = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME"      = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"      = azurerm_container_registry.acr.admin_password
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE"  = "false"
    "DOCKER_ENABLE_CI"                     = "true"
    
    # Container Port Configuration
    "WEBSITES_PORT"                        = "8080"
    "ASPNETCORE_ENVIRONMENT"               = "Production"
    
    # Database Connection String
    "ConnectionStrings__DefaultConnection" = "Server=${azurerm_mssql_server.main.fully_qualified_domain_name};Database=${azurerm_mssql_database.users.name};User Id=${var.sql_admin_username};Password=${var.sql_admin_password};TrustServerCertificate=True;"
    
    # JWT Settings
    "JwtSettings__SecretKey"                    = "z3F+7sR8vN5YlG1aXb2j8KqH0yL9uD3vM4pQ5rT6sU8="
    "JwtSettings__Issuer"                       = "FCG-User"
    "JwtSettings__Audience"                     = "FCG-Client"
    "JwtSettings__AccessTokenExpirationMinutes" = "60"
    "JwtSettings__RefreshTokenExpirationDays"   = "7"
    
    # Application Insights
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.users.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = azurerm_application_insights.users.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    "APPINSIGHTS_PROFILERFEATURE_VERSION"        = "1.0.0"
    "APPINSIGHTS_SNAPSHOTFEATURE_VERSION"        = "1.0.0"
    "DiagnosticServices_EXTENSION_VERSION"       = "~3"
    "InstrumentationEngine_EXTENSION_VERSION"    = "disabled"
    "SnapshotDebugger_EXTENSION_VERSION"         = "disabled"
    "XDT_MicrosoftApplicationInsights_BaseExtensions" = "disabled"
    "XDT_MicrosoftApplicationInsights_Mode"      = "recommended"
    "XDT_MicrosoftApplicationInsights_PreemptSdk" = "disabled"
    "APPLICATIONINSIGHTS_CONFIGURATION_CONTENT"  = ""
    
    # Kafka/Event Hub Settings
    "KafkaSettings__BootstrapServers"     = "${azurerm_eventhub_namespace.main.name}.servicebus.windows.net:9093"
    "KafkaSettings__SaslUsername"         = "$ConnectionString"
    "KafkaSettings__SaslPassword"         = azurerm_eventhub_namespace.main.default_primary_connection_string
    "KafkaSettings__UserCreatedTopic"     = azurerm_eventhub.user_created.name
  }
}

# SQL Server
resource "azurerm_mssql_server" "main" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.main.name
  location                     = var.sql_location
  version                      = var.sql_server_version
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"
  tags                         = var.tags

  public_network_access_enabled = true
}

# SQL Database - Catalog
resource "azurerm_mssql_database" "catalog" {
  name           = "fcg_catalog"
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 2
  sku_name       = var.sql_database_sku
  zone_redundant = false
  tags           = var.tags
}

# SQL Database - Users
resource "azurerm_mssql_database" "users" {
  name           = "fcg_users"
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 2
  sku_name       = var.sql_database_sku
  zone_redundant = false
  tags           = var.tags
}

# SQL Database - Payments
resource "azurerm_mssql_database" "payments" {
  name           = "fcg_payments"
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 2
  sku_name       = var.sql_database_sku
  zone_redundant = false
  tags           = var.tags
}

# Firewall Rule - Allow Azure Services
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Firewall Rules - Custom IPs
resource "azurerm_mssql_firewall_rule" "custom_ips" {
  for_each         = var.sql_allowed_ips
  name             = each.key
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = each.value
  end_ip_address   = each.value
}

# API Management
resource "azurerm_api_management" "main" {
  name                = var.apim_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  publisher_name      = var.apim_publisher_name
  publisher_email     = var.apim_publisher_email
  sku_name            = var.apim_sku_name
  tags                = var.tags

  public_network_access_enabled = true
}

# Event Hub Namespace (Kafka-enabled)
resource "azurerm_eventhub_namespace" "main" {
  name                = var.eventhub_namespace_name
  location            = var.eventhub_location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = var.eventhub_namespace_sku
  capacity            = var.eventhub_namespace_capacity
  tags                = var.tags

  minimum_tls_version           = "1.2"
  public_network_access_enabled = true
  zone_redundant                = true
}

# Event Hub - User Created
resource "azurerm_eventhub" "user_created" {
  name                = var.eventhub_user_created_name
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = azurerm_resource_group.main.name
  partition_count     = var.eventhub_partition_count
  message_retention   = var.eventhub_message_retention
}

# Event Hub - Payment Processed
resource "azurerm_eventhub" "payment_processed" {
  name                = var.eventhub_payment_processed_name
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = azurerm_resource_group.main.name
  partition_count     = var.eventhub_partition_count
  message_retention   = var.eventhub_message_retention
}

# Event Hub - Order Placed
resource "azurerm_eventhub" "order_placed" {
  name                = var.eventhub_order_placed_name
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = azurerm_resource_group.main.name
  partition_count     = var.eventhub_partition_count
  message_retention   = var.eventhub_message_retention
}

# Application Insights - Users
resource "azurerm_application_insights" "users" {
  name                = var.app_insights_users_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "web"
  retention_in_days   = var.app_insights_retention_days
  tags                = var.tags

  workspace_id = var.app_insights_workspace_id
}
