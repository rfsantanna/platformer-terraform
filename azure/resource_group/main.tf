data "azurerm_resource_group" "resource_group" {
  name = var.create_resource_group ? azurerm_resource_group.new_group.0.name : var.resource_group_name
}

resource "azurerm_resource_group" "new_group" {
  count               = var.create_resource_group ? 1 : 0
  name                = var.resource_group_name
  location            = var.resource_group_location 
}


