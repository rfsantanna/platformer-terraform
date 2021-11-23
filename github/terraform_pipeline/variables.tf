variable "environment" {
  type = string
  default = "prd"
}

variable "pipeline_vars" {
  type = map(any)
  default = {}
}

variable "repository" {
  type = string
}

variable "backend" {
  type = map(any)
  default = {}
}
