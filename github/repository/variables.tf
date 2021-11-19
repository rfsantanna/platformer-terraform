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

variable "workflow_vars" {
  type    = map(any)
  default = {}
}

variable "files" {
  type    = map(any)
  default = {}
}
