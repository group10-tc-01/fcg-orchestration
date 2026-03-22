resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_application_insights" "main" {
  name                = var.application_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  tags                = var.tags

  lifecycle {
    ignore_changes = [workspace_id]
  }
}

resource "azurerm_service_plan" "main" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.service_plan_sku
  tags                = var.tags
}

resource "azurerm_linux_function_app" "main" {
  name                       = var.function_app_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  service_plan_id            = azurerm_service_plan.main.id
  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key
  https_only                 = true
  tags                       = var.tags

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      dotnet_version              = "8.0"
      use_dotnet_isolated_runtime = true
    }

    application_insights_connection_string = azurerm_application_insights.main.connection_string
    application_insights_key               = azurerm_application_insights.main.instrumentation_key
  }

  app_settings = merge(
    {
      "APPLICATIONINSIGHTS_CONNECTION_STRING"      = azurerm_application_insights.main.connection_string
      "AzureWebJobsStorage"                        = azurerm_storage_account.main.primary_connection_string
      "EventHubConnection"                         = var.eventhub_connection_string
      "EventHubSettings__ConsumerGroup"            = var.eventhub_consumer_group
      "EventHubSettings__Topics__PaymentProcessed" = var.eventhub_payment_processed_name
      "EventHubSettings__Topics__UserCreated"      = var.eventhub_user_created_name
      "FUNCTIONS_EXTENSION_VERSION"                = "~4"
      "FUNCTIONS_WORKER_RUNTIME"                   = "dotnet-isolated"
    },
    var.email_connection_string == null ? {} : {
      "EmailSettings__ConnectionString" = var.email_connection_string
    },
    var.email_sender_address == "" ? {} : {
      "EmailSettings__SenderAddress" = var.email_sender_address
    }
  )
}
