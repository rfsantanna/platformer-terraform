terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
  required_version = ">= 0.13"
}

module "vm_rg" {
  source = "git::https://github.com/rfsantanna/infracode-terraform//azure/resource_group"
  resource_group_name = var.resource_group_name
  resource_group_location = var.location
  create_resource_group = var.create_resource_group
}

module "vm_network" {
  source              = "git::https://github.com/rfsantanna/infracode-terraform//azure/vm_network"
  vnet_name           = "${var.name}-vnet"
  vnet_addr           = var.vnet_addr
  subnet_name         = "${var.name}-subnet"
  subnet_addr         = var.subnet_addr
  dynamic_ip          = var.dynamic_ip
  resource_group_name = module.vm_rg.resource_group.name
  depends_on = [
    module.vm_rg
  ]
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.name
  resource_group_name             = module.vm_rg.resource_group.name
  location                        = module.vm_rg.resource_group.location
  size                            = var.size
  priority                        = "Spot"
  eviction_policy                 = "Deallocate"
  disable_password_authentication = true
  admin_username                  = var.admin_username
  custom_data                     = data.cloudinit_config.config.rendered

  network_interface_ids = [
    module.vm_network.nic.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_publickey
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.disk_type
    disk_size_gb         = var.disk_size
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

data "azurerm_public_ip" "updated" {
  name                = module.vm_network.public_ip.name
  resource_group_name = module.vm_network.vnet_rg.name
  depends_on = [
    azurerm_linux_virtual_machine.vm
  ]
}

data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  dynamic "part" {
    for_each = var.init_config_list
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

