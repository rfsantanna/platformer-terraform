variable "name" { type = string }
variable "location" { type = string }
variable "size" { type = string }
variable "resource_group_name" { type = string }
variable "subnet_addr" { type = string }
variable "vnet_addr" { type = string }
variable "admin_username" { type = string }
variable "admin_publickey" { type = string }
variable "disk_size" { type = string }
variable "disk_type" { type = string }
variable "dynamic_ip" {
  type    = bool
  default = true
}
variable "create_resource_group" {
  type    = bool
  default = false
}

variable "init_config_list" {
  type = list(any)
  default = [
    {
      template = "basic"
      vars     = {}
    }
  ]
}

variable "script_list" {
  type    = list(any)
  default = []
}

