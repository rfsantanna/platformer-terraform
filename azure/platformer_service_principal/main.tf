terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=1.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=2.3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.29.0"
    }
  }
}

data "azuread_client_config" "current" {}
data "azurerm_client_config" "current" {}

resource "random_string" "id" {
  length  = 8
  special = false
  upper   = false
  number  = true
}

resource "azuread_application" "app" {
  display_name = "${var.name}_${random_string.id.result}"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "sp" {
  application_id               = azuread_application.app.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "secret" {
  service_principal_id = azuread_service_principal.sp.object_id
}

resource "azurerm_resource_group" "rg" {
  name     = "iac-${azuread_application.app.display_name}"
  location = "brazilsouth"
}

resource "azurerm_role_assignment" "owner" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.sp.object_id
}

resource "azurerm_storage_account" "stacc" {
  name                     = "platformer${random_string.id.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "blob" {
  name                  = "terraform-base"
  storage_account_name  = azurerm_storage_account.stacc.name
  container_access_type = "private"
}
