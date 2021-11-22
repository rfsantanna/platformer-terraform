variable "name" {
  type = string
}

variable "environments" {
  type    = list(string)
  default = ["default"] 
}
