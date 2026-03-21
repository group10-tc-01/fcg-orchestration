module "resource_group" {
  source = "./modules/resource_group"

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

module "acr" {
  source = "./modules/acr"

  acr_name            = var.acr_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  acr_sku             = var.acr_sku
  acr_admin_enabled   = var.acr_admin_enabled
  tags                = var.tags
}

module "database" {
  source = "./modules/database"

  resource_group_name = module.resource_group.name
  sql_location        = var.sql_location
  sql_server_name     = var.sql_server_name
  sql_server_version  = var.sql_server_version
  sql_admin_username  = var.sql_admin_username
  sql_admin_password  = var.sql_admin_password
  sql_database_sku    = var.sql_database_sku
  sql_allowed_ips     = var.sql_allowed_ips
  tags                = var.tags
}

module "eventhub" {
  source = "./modules/eventhub"

  resource_group_name             = module.resource_group.name
  eventhub_namespace_name         = var.eventhub_namespace_name
  eventhub_location               = var.eventhub_location
  eventhub_namespace_sku          = var.eventhub_namespace_sku
  eventhub_namespace_capacity     = var.eventhub_namespace_capacity
  eventhub_user_created_name      = var.eventhub_user_created_name
  eventhub_payment_processed_name = var.eventhub_payment_processed_name
  eventhub_order_placed_name      = var.eventhub_order_placed_name
  eventhub_partition_count        = var.eventhub_partition_count
  eventhub_message_retention      = var.eventhub_message_retention
  tags                            = var.tags
}

module "keyvault" {
  source = "./modules/keyvault"

  key_vault_name      = var.key_vault_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  tags                = var.tags

  webapp_principal_ids = module.webapp.webapp_principal_ids

  sql_server_fqdn            = module.database.server_fqdn
  sql_admin_username         = var.sql_admin_username
  sql_admin_password         = var.sql_admin_password
  sql_database_catalog_name  = module.database.database_catalog_name
  sql_database_users_name    = module.database.database_users_name
  sql_database_payments_name = module.database.database_payments_name
}

module "webapp" {
  source = "./modules/webapp"

  resource_group_name   = module.resource_group.name
  location              = module.resource_group.location
  app_service_plan_name = var.app_service_plan_name
  app_service_plan_sku  = var.app_service_plan_sku
  webapp_catalog_name   = var.webapp_catalog_name
  webapp_payments_name  = var.webapp_payments_name
  webapp_users_name     = var.webapp_users_name
  docker_image_tag      = var.docker_image_tag

  acr_login_server   = module.acr.login_server
  acr_admin_username = module.acr.admin_username
  acr_admin_password = module.acr.admin_password

  kv_secret_conn_catalog_uri  = module.keyvault.secret_conn_catalog_uri
  kv_secret_conn_users_uri    = module.keyvault.secret_conn_users_uri
  kv_secret_conn_payments_uri = module.keyvault.secret_conn_payments_uri

  eventhub_kafka_endpoint    = module.eventhub.kafka_endpoint
  eventhub_connection_string = module.eventhub.namespace_connection_string
  eventhub_user_created_name = module.eventhub.eventhub_user_created_name

  tags = var.tags
}

module "apim" {
  source = "./modules/apim"

  resource_group_name  = module.resource_group.name
  location             = module.resource_group.location
  apim_name            = var.apim_name
  apim_publisher_name  = var.apim_publisher_name
  apim_publisher_email = var.apim_publisher_email
  apim_sku_name        = var.apim_sku_name
  tags                 = var.tags
}
