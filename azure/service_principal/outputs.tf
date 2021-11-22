output "service_principal" {
  value = azuread_service_principal.sp
}

output "resource_group" {
  value = azurerm_resource_group.rg
}

output "terraform_files" {
  value = {
    ".platformer/defaults.tf" = templatefile(
      "${path.module}/base.tf.tpl", {
        resource_group_name  = azurerm_resource_group.rg["prd"].name
        storage_account_name = azurerm_storage_account.stacc["prd"].name
        container_name       = azurerm_storage_container.blob["prd"].name
        key                  = "main.tfstate"
      }
    )
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
