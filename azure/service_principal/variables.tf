variable "name" {
  type = string
}

variable "environments" {
  type    = map(any)
  default = {
    prd = {}
  }
}
