variable "triggers" {
  type        = map(any)
  description = "Triggers to run ansible"
  default     = {}
}

variable "hosts" {
  description = "Hosts List"
  sensitive   = true
  type        = list(any)
}

variable "extra_vars" {
  type        = map(any)
  description = "Extra Parameters to ansible inventory"
  default     = {}
}

variable "extra_groups" {
  type        = map(list(string))
  description = "Additional groups on inventory"
  default     = {}
}

variable "children_groups" {
  type        = map(list(string))
  description = "Children groups"
  default     = {}
}

variable "run_playbook" {
  type        = string
  default     = ""
  description = "Playbook to run"
}

variable "inventory_filename" {
  type    = string
  default = "ansible-inventory"
}

variable "python_interpreter" {
  type    = string
  default = "/usr/bin/python3"
}

variable "galaxy_install_collections" {
  type = list(string)
  default = []
}

variable "galaxy_install_roles" {
  type    = list(string)
  default = []
}

variable "galaxy_requirements" {
  type    = string
  default = ""
}

variable "inventory_trigger" {
  type    = bool
  default = true
}

