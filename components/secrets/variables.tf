variable "tags" {
  type = map(any)
  default = {
  }
}

variable "secret_name" {
  type = string
}

variable "secret_value" {
  type = map(any)
  default = {
  }
}
