terraform {
  required_version = ">= 1.0.7"
  backend "azurerm" {
    resource_group_name  = "${resource_group_name}"
    storage_account_name = "${storage_account_name}" 
    container_name       = "${container_name}"
    key                  = "${key}"
  }
}

provider "azurerm" {
  skip_credentials_validation = true
  features {
    key_vault {
      recover_soft_deleted_key_vaults = true
      purge_soft_delete_on_destroy    = false
    }
  }
}

