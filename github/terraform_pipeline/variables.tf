variable "environment" {
  type = string
  default = "prd"
}

variable "pipeline_vars" {
  type = map()
  default = {}
}

variable "repository" {
  type = string
}
