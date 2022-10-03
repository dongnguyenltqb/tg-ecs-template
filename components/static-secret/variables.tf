variable "tags" {
  type = map(any)
  default = {
  }
}

variable "static_secret_name" {
  type = string
}

variable "static_secret_value" {
  type = map(any)
  default = {
  }
}
