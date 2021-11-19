output "service_principal" {
  value = azuread_service_principal.sp
}

output "resource_group" {
  value = azurerm_resource_group.rg
}

output "appsecret" {
  value = azuread_service_principal_password.secret.value
}

output "terraform_repo_files" {
  value = {
    ".platformer/defaults.tf" = templatefile(
      "${path.module}/base.tf.tpl", {
        resource_group_name  = azurerm_resource_group.rg.name
        storage_account_name = azurerm_storage_account.stacc.name
        container_name       = azurerm_storage_container.blob.name
        key                  = "main.tfstate"
      }
    )
  }
}

output "pipeline_vars" {
  value = {
    ARM_TENANT_ID       = data.azurerm_client_config.current.tenant_id
    ARM_SUBSCRIPTION_ID = data.azurerm_client_config.current.subscription_id
    ARM_CLIENT_ID       = azuread_application.app.application_id
  }
}
