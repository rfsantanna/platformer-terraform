variable "name" { type = string }
variable "location" { type = string }
variable "size" { type = string }
variable "resource_group_name" { type = string }
variable "subnet_addr" { type = string }
variable "subnet_name" { type = string }
variable "vnet_addr" { type = string }
variable "vnet_name" { type = string }
variable "admin_username" { type = string }
variable "admin_publickey" { type = string }
variable "disk_size" {
  type = string
  default = "60"
}
variable "disk_type" {
  type = string
  default = "Standard_LRS"
}
variable "dynamic_ip" {
  type    = bool
  default = true
}
variable "create_resource_group" {
  type    = bool
  default = false
}

variable "init_configs" {
  type = map(any)
  default = {
    basic = {}
  }
}

variable "init_scripts" {
  type = map(any)
  default = {}
}

