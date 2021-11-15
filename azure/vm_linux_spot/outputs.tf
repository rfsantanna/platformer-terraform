output "public_ip" {
  value = data.azurerm_public_ip.updated
}

output "vm" {
  value = {
    id              = azurerm_linux_virtual_machine.vm.id
    name            = azurerm_linux_virtual_machine.vm.name
    size            = azurerm_linux_virtual_machine.vm.size
    resource_group  = azurerm_linux_virtual_machine.vm.resource_group_name
    location        = azurerm_linux_virtual_machine.vm.location
    admin_username  = azurerm_linux_virtual_machine.vm.admin_username
    priority        = azurerm_linux_virtual_machine.vm.priority
    eviction_policy = azurerm_linux_virtual_machine.vm.eviction_policy
    private_ip      = azurerm_linux_virtual_machine.vm.private_ip_address
    public_ip       = azurerm_linux_virtual_machine.vm.public_ip_address
    image           = azurerm_linux_virtual_machine.vm.source_image_reference[0]
    os_disk         = azurerm_linux_virtual_machine.vm.os_disk[0]
  }
}

output "vm_full" {
  value     = azurerm_linux_virtual_machine.vm
  sensitive = true
}

output "ansible_host" {
  sensitive = true
  value = {
    name           = azurerm_linux_virtual_machine.vm.name
    ip_address     = azurerm_linux_virtual_machine.vm.public_ip_address
    admin_username = azurerm_linux_virtual_machine.vm.admin_username
    admin_password = azurerm_linux_virtual_machine.vm.admin_password
  }
}
