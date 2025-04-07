variable "location" {
  default = "East US"
}

variable "resource_group_name" {
  default = "lead-tracker-rg"
}

variable "vm_name" {
  default = "leadtracker-vm"
}

variable "env" {
  description = "Deployment environment"
  type        = string
}
