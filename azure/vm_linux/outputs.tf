output "machine" {
  value = {
    machine_name       = azurerm_linux_virtual_machine.machine.name
    resouce_group_name = data.azurerm_resource_group.rg.name
    admin_username     = azurerm_linux_virtual_machine.machine.admin_username
    machine_size       = azurerm_linux_virtual_machine.machine.size
    keyvault_name      = var.key_vault_name 
    computer_name      = azurerm_linux_virtual_machine.machine.computer_name
    private_ip         = azurerm_linux_virtual_machine.machine.private_ip_address
    public_ip          = azurerm_linux_virtual_machine.machine.public_ip_address
  }
}

output "secrets" {
  value = {
    admin_password     = azurerm_linux_virtual_machine.machine.admin_password
  }
}

