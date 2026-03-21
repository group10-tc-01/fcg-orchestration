resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku
  tags                = var.tags
}

resource "azurerm_linux_web_app" "catalog" {
  name                = var.webapp_catalog_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true
  tags                = var.tags

  site_config {
    always_on = true
    application_stack {
      docker_image_name   = "${var.acr_login_server}/fcg-catalog:${var.docker_image_tag}"
      docker_registry_url = "https://${var.acr_login_server}"
    }
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"           = "https://${var.acr_login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME"      = var.acr_admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"      = var.acr_admin_password
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE"  = "false"

    "WEBSITES_PORT"        = "8080"
    "ASPNETCORE_ENVIRONMENT" = "Production"

    "ConnectionStrings__DefaultConnection" = "Server=${var.sql_server_fqdn};Database=${var.sql_database_catalog_name};User Id=${var.sql_admin_username};Password=${var.sql_admin_password};TrustServerCertificate=True;"

    "JwtSettings__SecretKey"                    = "z3F+7sR8vN5YlG1aXb2j8KqH0yL9uD3vM4pQ5rT6sU8="
    "JwtSettings__Issuer"                       = "FCG-Catalog"
    "JwtSettings__Audience"                     = "FCG-Client"
    "JwtSettings__AccessTokenExpirationMinutes" = "60"
    "JwtSettings__RefreshTokenExpirationDays"   = "7"
  }
}

resource "azurerm_linux_web_app" "payments" {
  name                = var.webapp_payments_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true
  tags                = var.tags

  site_config {
    always_on = true
    application_stack {
      docker_image_name   = "${var.acr_login_server}/fcg-payments:${var.docker_image_tag}"
      docker_registry_url = "https://${var.acr_login_server}"
    }
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"           = "https://${var.acr_login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME"      = var.acr_admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"      = var.acr_admin_password
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE"  = "false"

    "WEBSITES_PORT"        = "8080"
    "ASPNETCORE_ENVIRONMENT" = "Production"

    "ConnectionStrings__DefaultConnection" = "Server=${var.sql_server_fqdn};Database=${var.sql_database_payments_name};User Id=${var.sql_admin_username};Password=${var.sql_admin_password};TrustServerCertificate=True;"

    "JwtSettings__SecretKey"                    = "z3F+7sR8vN5YlG1aXb2j8KqH0yL9uD3vM4pQ5rT6sU8="
    "JwtSettings__Issuer"                       = "FCG-Payments"
    "JwtSettings__Audience"                     = "FCG-Client"
    "JwtSettings__AccessTokenExpirationMinutes" = "60"
    "JwtSettings__RefreshTokenExpirationDays"   = "7"
  }
}

resource "azurerm_linux_web_app" "users" {
  name                = var.webapp_users_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true
  tags                = var.tags

  site_config {
    always_on = true
    application_stack {
      docker_image_name   = "${var.acr_login_server}/fcg-users:${var.docker_image_tag}"
      docker_registry_url = "https://${var.acr_login_server}"
    }
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"           = "https://${var.acr_login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME"      = var.acr_admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"      = var.acr_admin_password
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE"  = "false"
    "DOCKER_ENABLE_CI"                     = "true"

    "WEBSITES_PORT"        = "8080"
    "ASPNETCORE_ENVIRONMENT" = "Production"

    "ConnectionStrings__DefaultConnection" = "Server=${var.sql_server_fqdn};Database=${var.sql_database_users_name};User Id=${var.sql_admin_username};Password=${var.sql_admin_password};TrustServerCertificate=True;"

    "JwtSettings__SecretKey"                    = "z3F+7sR8vN5YlG1aXb2j8KqH0yL9uD3vM4pQ5rT6sU8="
    "JwtSettings__Issuer"                       = "FCG-User"
    "JwtSettings__Audience"                     = "FCG-Client"
    "JwtSettings__AccessTokenExpirationMinutes" = "60"
    "JwtSettings__RefreshTokenExpirationDays"   = "7"

    "APPINSIGHTS_INSTRUMENTATIONKEY"             = var.app_insights_instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = var.app_insights_connection_string
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

    "KafkaSettings__BootstrapServers" = var.eventhub_kafka_endpoint
    "KafkaSettings__SaslUsername"     = "$ConnectionString"
    "KafkaSettings__SaslPassword"     = var.eventhub_connection_string
    "KafkaSettings__UserCreatedTopic" = var.eventhub_user_created_name
  }
}
