variable "project" {
  type = string
}
variable "tags" {
  type = map(any)
  default = {
  }
}

variable "profile_name" {
  type = string
}

variable "backend_secret_id" {
  type = string
}

variable "static_secret_id" {
  type = string
}

variable "backend_ecr_arn" {
  type = string
}

variable "static_ecr_arn" {
  type = string
}

variable "log_group_arn" {
  type = string
}
