variable "hosted_zone_domain_name" {
  type = string
}
variable "domain_name" {
  type = string
}

variable "tags" {
  type = map(any)
  default = {
  }
}
