output "service_principal" {
  value = azuread_service_principal.sp
}

output "resource_group" {
  value = azurerm_resource_group.rg
}

output "terraform_backend" {
  value = {
    for env, value in var.environments : env => {
      resource_group_name  = azurerm_resource_group.rg[env].name
      storage_account_name = azurerm_storage_account.stacc[env].name
      container_name       = azurerm_storage_container.blob[env].name
      key                  = "main.tfstate"
    }
  }
}

output "environments" {
  value = {
    for env, value in var.environments : env => {
      environment = {
        name     = env
        unsecure = lookup(value, "unsecure", false) ? "yes" : "no"
      }
      vars = {
        ARM_TENANT_ID       = data.azurerm_client_config.current.tenant_id
        ARM_SUBSCRIPTION_ID = data.azurerm_client_config.current.subscription_id
        ARM_CLIENT_ID       = azuread_application.app[env].application_id
      }
      secrets = {
        ARM_CLIENT_SECRET = azuread_service_principal_password.secret[env].value
      }
    }
  }
}
