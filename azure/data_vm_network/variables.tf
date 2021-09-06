variable "id" {type = string}
variable "vnet_name" {type = string}
variable "vnet_addr" {type = string}
variable "subnet_name" {type = string}
variable "subnet_addr" {type = string}
variable "dynamic_ip" {type = bool}
variable "resource_group_name" {type = string}
variable "static_ip" {
  type = string 
  default = "static-ip"
}
variable "static_rg" {
  type = string 
  default = "static-resources"
}
