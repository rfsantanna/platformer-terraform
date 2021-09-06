output "vnet" {
  value = data.azurerm_virtual_network.vnet.id
}

output "vnet_address" {
  value = data.azurerm_virtual_network.vnet.address_space
}

output "subnets" {
  value = data.azurerm_virtual_network.vnet.subnets
}

output "vnet_rg" {
  value = data.azurerm_virtual_network.vnet.resource_group_name
}

output "public_ip" {
  value = data.azurerm_public_ip.ip
}

output "nic" {
  value = azurerm_network_interface.nic
}


