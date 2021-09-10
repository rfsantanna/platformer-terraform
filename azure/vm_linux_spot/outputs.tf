output "public_ip" {
  value = data.azurerm_public_ip.updated
}

output "vm" {
  value = {
    name           = azurerm_linux_virtual_machine.vm.name
    resource_group = azurerm_linux_virtual_machine.vm.resource_group_name
    location       = azurerm_linux_virtual_machine.vm.location
    image          = azurerm_linux_virtual_machine.vm.source_image_reference
  }
}
