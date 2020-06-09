provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "maibeer"
  location = "brazilsouth"
}

resource "azurerm_cosmosdb_account" "default" {
  name                = "cosmos-maibeer-prototype"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  enable_automatic_failover = false

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }

}

resource "azurerm_cosmosdb_mongo_database" "default" {
  name                = "maibeer"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.default.name
  throughput          = 400
}

resource "azurerm_cosmosdb_sql_container" "questions" {
  name                = "questions"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.default.name
  database_name       = azurerm_cosmosdb_mongo_database.default.name
  partition_key_path  = "product"
}

resource "azurerm_cosmosdb_sql_container" "answers" {
  name                = "answers"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.default.name
  database_name       = azurerm_cosmosdb_mongo_database.default.name
  partition_key_path  = "address.zip"
}

output "cosmosdb_connection_strings" {
  value = azurerm_cosmosdb_account.default.connection_strings
}