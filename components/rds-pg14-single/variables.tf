variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "rds_subnets" {
  type        = list(string)
  description = "subnet ids"
}

variable "rds_availability_zones" {
  type = list(string)
}

variable "name" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type    = string
  default = "postgres"
}

variable "db_password" {
  type = string
}

variable "tags" {
  type = map(any)
  default = {
  }
}
