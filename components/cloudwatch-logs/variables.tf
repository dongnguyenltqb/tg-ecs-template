variable "log_group_name" {
  type = string
}

variable "tags" {
  type = map(any)
  default = {
  }
}
