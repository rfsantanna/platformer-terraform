variable "resource_group_name" {
  type = string 
}

variable "resource_group_location" {
  type    = string
  default = "brazilsouth"
}

variable "create_resource_group" {
  type    = bool
  default = false
}
