terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.1"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_client_config" "current" {}

# Configuration files
locals {
  env = merge(
    yamldecode(file("main.development.yaml"))
  )
}

resource "azurerm_resource_group" "rg" {
  name     = local.env.resource_group_name
  location = local.env.location
}

# COSMOS

resource "azurerm_cosmosdb_account" "default" {
  name                = local.env.cosmos_account_name
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

  lifecycle {
    prevent_destroy = true
  }

}

resource "azurerm_cosmosdb_mongo_database" "default" {
  name                = "myproj888"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.default.name
  throughput          = 400

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_cosmosdb_mongo_collection" "questions" {
  name                = "questions"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.default.name
  database_name       = azurerm_cosmosdb_mongo_database.default.name

  shard_key  = "product"
  throughput = 400

  index {
    keys   = ["_id"]
    unique = true
  }

  lifecycle {
    prevent_destroy = true
  }

}

resource "azurerm_cosmosdb_mongo_collection" "answers" {
  name                = "answers"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.default.name
  database_name       = azurerm_cosmosdb_mongo_database.default.name

  shard_key  = "address.zipcode"
  throughput = 400

  index {
    keys   = ["_id"]
    unique = true
  }

  lifecycle {
    prevent_destroy = true
  }

}

# STORAGE

resource "azurerm_storage_account" "default" {
  name                     = local.env.storage_name
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# FUNCTIONS

resource "azurerm_service_plan" "default" {
  name                = local.env.func_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "myproj888" {
  name                       = local.env.func_app_name
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  storage_account_name       = azurerm_storage_account.default.name
  storage_account_access_key = azurerm_storage_account.default.primary_access_key

  service_plan_id = azurerm_service_plan.default.id

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "python"
  }

  site_config {
    # only for free plan
    use_32_bit_worker = true
  }

  identity {
    type = "SystemAssigned"
  }
}

# KEYVAULT

resource "azurerm_key_vault" "prototype" {
  name                        = local.env.kv_name
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = false

  sku_name = "standard"

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "Create",
      "Delete",
      "Update"
    ]
  }
}

resource "azurerm_key_vault_key" "generated" {
  name         = "generated-key"
  key_vault_id = azurerm_key_vault.prototype.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt"
  ]
}

resource "azurerm_key_vault_access_policy" "function" {
  key_vault_id = azurerm_key_vault.prototype.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_linux_function_app.myproj888.identity[0].principal_id

  key_permissions = [
    "Get",
    "Decrypt",
    "Encrypt"
  ]
}

# OUTPUTS

output "cosmosdb_connection_strings" {
  value = azurerm_cosmosdb_account.default.connection_strings
  sensitive = true
}

output "vault_uri" {
  value = azurerm_key_vault.prototype.vault_uri
}

output "function_identity" {
  value = azurerm_linux_function_app.myproj888.identity
}
