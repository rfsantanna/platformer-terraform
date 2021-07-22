terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}

locals {
  vm_vars          = yamldecode(file("${path.module}/vars.yaml"))
  vm_name          = var.machine_name
  vm_size          = local.vm_vars.machine_sizes[var.size]
  vm_os            = local.vm_vars.os_type[var.os]
  vm_os_disk       = local.vm_vars.os_disk[var.os_disk]
  init_config_list = length(var.init_config_list) == 0 ? [{ template = "basic", vars = {} }] : var.init_config_list
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = var.virtual_network_rg
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = var.virtual_network_rg
}

resource "random_id" "unique" {
  byte_length = 6
}

resource "azurerm_public_ip" "ip" {
  count               = var.public_ip ? 1 : 0
  name                = "${local.vm_name}-ip-dyn"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  name                = var.public_ip ? "${local.vm_name}-nic-pub-${random_id.unique.id}" : "${local.vm_name}-nic-${random_id.unique.id}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${local.vm_name}-ip-${random_id.unique.id}"
    public_ip_address_id          = var.public_ip ? azurerm_public_ip.ip.0.id : null
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.machine_ip
  }
  tags = {
    area = var.area_name
  }
}

resource "random_password" "machine_secret" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "azurerm_linux_virtual_machine" "machine" {
  name                            = var.public_ip ? "${local.vm_name}-pub" : local.vm_name
  computer_name                   = local.vm_name
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  size                            = local.vm_size.machine_size
  admin_username                  = "adminschedule"
  admin_password                  = random_password.machine_secret.result
  disable_password_authentication = false
  custom_data                     = data.cloudinit_config.config.rendered

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  source_image_reference {
    publisher = local.vm_os.image_publisher
    offer     = local.vm_os.image_offer
    sku       = local.vm_os.image_sku
    version   = local.vm_os.image_version
  }

  os_disk {
    storage_account_type = local.vm_os_disk.type
    caching              = "ReadWrite"
    disk_size_gb         = local.vm_os_disk.size
  }

  tags = {
    area = var.area_name
  }
}

data "azurerm_key_vault" "kv" {
  count               = var.key_vault_name == "" ? 0 : 1
  name                = var.key_vault_name
  resource_group_name = "infraplataforma"
}

resource "azurerm_key_vault_secret" "secret" {
  count        = var.key_vault_name == "" ? 0 : 1
  name         = local.vm_name
  value        = random_password.machine_secret.result
  key_vault_id = data.azurerm_key_vault.kv.0.id

  tags = {
    area = var.area_name
  }
}

data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  dynamic "part" {
    for_each = local.init_config_list
    content {
      content_type = "text/cloud-config"
      content      = templatefile("${path.module}/../../templates/cloudinit/${part.value.template}.yaml", part.value.vars)
      merge_type   = "dict(recurse_array)+list(append)"
    }
  }

  dynamic "part" {
    for_each = var.script_list
    content {
      content_type = "text/x-shellscript"
      content      = templatefile("${path.module}/../../templates/bash/${part.value.template}.sh", part.value.vars)
    }
  }
}


resource "azurerm_network_security_group" "nsg" {
  name                = "${local.vm_name}-ssh-nsg"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = var.env == "development" ? "*" : azurerm_linux_virtual_machine.machine.private_ip_address
  }
}


resource "azurerm_network_interface_security_group_association" "nic-nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

data "azurerm_virtual_machine" "updated" {
  name                = azurerm_linux_virtual_machine.machine.name
  resource_group_name = data.azurerm_resource_group.rg.name
  depends_on = [
    azurerm_linux_virtual_machine.machine
  ]
}
