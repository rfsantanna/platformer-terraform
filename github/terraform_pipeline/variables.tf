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

variable "files" {
  type = map(any)
  default = {}
}
