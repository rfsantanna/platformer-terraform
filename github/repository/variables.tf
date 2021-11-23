variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = "Created by platformer"
}

variable "visibility" {
  type    = string
  default = "public"
}

variable "action_secrets" {
  type    = map(any)
  default = {}
}

variable "archived" {
  type    = bool
  default = false
}

variable "exists" {
  type    = bool
  default = false
}

variable "environments" {
  type    = map(any)
  default = {}
}

variable "workflow_vars" {
  type    = map(any)
  default = {}
}

variable "terraform_backend" {
  type    = map(any)
  default = {}
}
