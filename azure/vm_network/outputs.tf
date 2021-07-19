output "vnet" {
  value = module.vnet.vnet_id
}

output "vnet_address" {
  value = module.vnet.vnet_address_space
}

output "subnets" {
  value = module.vnet.vnet_subnets
}

output "vnet_rg" {
  value = data.azurerm_resource_group.vnet_rg
}

output "public_ip" {
  value = data.azurerm_public_ip.ip
}

output "nic" {
  value = azurerm_network_interface.nic
}


