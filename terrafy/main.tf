provider "azurerm" {
 features {}
}

data "azurerm_client_config" "current" {}

resource "random_id" "rand" {
 byte_length = 2
}

locals {
 environment = var.env 
}

resource "azurerm_resource_group" "rg" {
 name = "terrafy-${local.environment}-rg"
 location = var.location
}

resource "azure_virtual_network" "vnet" {
 name = "terrafy-${local.environment}-vnet"
 address_space = ["10.0.0.0/16"]
 location = azurerm_resource_group.rg.location
 resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "nsg" {
 name = "terrafy-${local.environment}-nsg"
 location = azurerm_resource_group.rg.location
 resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
 name = "allow-ssh"
 priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.my_ip
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
 }
 
resource "azurerm_storage_account" "storage" {
 name                     = "terrafystorage${random_id.rand.hex}"
 resource_group_name      = azurerm_resource_group.rg.name
 location                 = azurerm_resource_group.rg.location
 account_tier             = "Standard"
 account_replication_type = "LRS"
}

resource "azurerm_key_vault" "kv" {
  name                        = "terrafykv${random_id.rand.hex}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_enabled         = true
  purge_protection_enabled    = true
   
    access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["get", "list", "set", "delete"]
  }
}

resource "azurerm_mssql_server" "sql" {
  name                         = "terrafysql${random_id.rand.hex}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_user
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "db" {
  name      = "terrafy-${local.environment}-db"
  server_id = azurerm_mssql_server.sql.id
  sku_name  = "Basic"
}

resource "azurerm_servicebus_namespace" "sb" {
  name                = "terrafysb${random_id.rand.hex}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
}

resource "azurerm_app_service_plan" "plan" {
  name                = "terrafy-${local.environment}-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "fn" {
  name                       = "terrafyfn${random_id.rand.hex}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  version                    = "~4"

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet"
  }
}