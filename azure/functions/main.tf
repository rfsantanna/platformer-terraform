terraform {
  required_providers {
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

resource "random_string" "id" {
  length  = 8
  special = false
  upper   = false
  number  = true
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.name}-func"
  location = "brazilsouth"
}

resource "azurerm_storage_account" "stacc" {
  name                     = "platformer${random_string.id.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "app" {
  name                = var.name
  location            = "brazilsouth"
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FunctionApp"
  reserved            = true
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "app" {
  name                       = var.name
  location                   = azurerm_app_service_plan.app.location
  resource_group_name        = azurerm_app_service_plan.app.resource_group_name
  app_service_plan_id        = azurerm_app_service_plan.app.id
  storage_account_name       = azurerm_storage_account.stacc.name
  storage_account_access_key = azurerm_storage_account.stacc.primary_access_key
  version                    = "~3"
  os_type                    = "linux"

  site_config {
    linux_fx_version          = "PYTHON|3.9"
    use_32_bit_worker_process = false
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
  }
}

resource "null_resource" "functions" {
  triggers = {
    app_name         = azurerm_function_app.app.name
    linux_fx_version = azurerm_function_app.app.site_config[0].linux_fx_version
  }
  provisioner "local-exec" {
    command = <<EOT
    az login --service-principal -u $ARM_CLIENT_ID -p "$ARM_CLIENT_SECRET" --tenant $ARM_TENANT_ID
    cd functions && func init . --worker-runtime python 
    func azure functionapp publish ${azurerm_function_app.app.name}
    EOT
  }
}
