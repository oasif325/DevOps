variable "resource_group_name" {
 description = "Name of the resource group"
 default = "terrafy-rg"
}

variable "location" {
 description = "Azure region"
 default = "East US"
}

variable "sql_admin_user" {
 description = "terrafyadmin"
 type = string
}

variable "sql_admin_password" {
 description = "Password!123"
 type = string
 sensitive = true
}

variable "env" {
  description = "Deployment environment"
  type        = string
}
