provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "maibeer"
  location = "brazilsouth"
}

resource "azurerm_cosmosdb_account" "db" {
  name                = "cosmos-maibeer-prototype"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  enable_automatic_failover = false

  consistency_policy {
    consistency_level = "Sesssion"
  }

  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }

}
