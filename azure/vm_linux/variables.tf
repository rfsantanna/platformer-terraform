variable "machine_name" { type = string }
variable "machine_ip" { type = string }
variable "area_name" { type = string }

variable "env" {
  type    = string
  default = "development"
}

variable "set_key_vault_secret" {
  type    = bool
  default = true
}

variable "resource_group_name" {
  type    = string
  default = "infraplataforma"
}

variable "key_vault_name" {
  type    = string
  default = "azdo-Machines-dev"
}

variable "virtual_network_rg" {
  type    = string
  default = "infraplataforma"
}

variable "virtual_network_name" {
  type    = string
  default = "rede-azdo-automation"
}

variable "subnet_name" {
  type    = string
  default = "azdo-automation"
}

variable "size" {
  type    = string
  default = "small"
}

variable "os" {
  type    = string
  default = "ubuntu_18_04"
}

variable "os_disk" {
  type    = string
  default = "small"
}

variable "public_ip" {
  type    = bool
  default = false
}

variable "init_config_list" {
  type = list(any)
  default = []
}

variable "script_list" {
  type    = list(any)
  default = []
}
