variable "project" {
  type     = string
  nullable = false
}

variable "tags" {
  type = map(any)
  default = {
  }
  nullable = false
}

variable "vpc_id" {
  type     = string
  nullable = false
}

variable "subnet_id" {
  type        = string
  nullable    = false
  description = "the public subnet id where instance will be placed."
}

variable "key_name" {
  type        = string
  nullable    = false
  description = "the ssh key name which allow to access vpn instance."
}

variable "admin_user" {
  type        = string
  nullable    = false
  description = "the openvpn admin account username"
}

variable "admin_password" {
  type        = string
  nullable    = false
  description = "the openvpn admin account password."
}



