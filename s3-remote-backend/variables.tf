variable "region" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "tags" {
  type = map(any)
  default = {
  }
}
