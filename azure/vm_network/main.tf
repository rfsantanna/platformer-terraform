terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
  required_version = ">= 0.13"
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "vnet_rg" {
  name = var.resource_group_name
}

data "azurerm_public_ip" "ip" {
  name                = var.dynamic_ip ? azurerm_public_ip.ip.0.name : var.static_ip
  resource_group_name = var.dynamic_ip ? data.azurerm_resource_group.vnet_rg.name : var.static_rg
}

resource "azurerm_public_ip" "ip" {
  count               = var.dynamic_ip ? 1 : 0
  name                = "${var.vnet_name}-ip-dyn"
  resource_group_name = data.azurerm_resource_group.vnet_rg.name
  location            = data.azurerm_resource_group.vnet_rg.location
  allocation_method   = "Dynamic"
}

module "vnet" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = var.resource_group_name
  vnet_name           = var.vnet_name
  address_space      = [var.vnet_addr]
  subnet_prefixes     = [var.subnet_addr]
  subnet_names        = ["${var.vnet_name}-subnet"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.vnet_name}-nsg"
  resource_group_name = data.azurerm_resource_group.vnet_rg.name
  location            = data.azurerm_resource_group.vnet_rg.location

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.vnet_name}-nic"
  resource_group_name = data.azurerm_resource_group.vnet_rg.name
  location            = data.azurerm_resource_group.vnet_rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = data.azurerm_public_ip.ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic-nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

