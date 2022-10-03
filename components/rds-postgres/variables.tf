variable "parameter_group_name" {
  type    = string
  default = null
}
variable "region" {
  type = string
}

variable "tags" {
  type = map(any)
  default = {
  }
}
variable "project" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "source_security_group_ids" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "db_credentials" {
  type = object({
    db_name  = string
    username = string
    password = string
  })
}

