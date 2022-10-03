variable "nlb_name" {
  type = string
}
variable "nlb_cert_arn" {
  type = string
}
variable "nlb_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}
variable "tags" {
  type = map(any)
  default = {
  }
}

variable "allow_rules" {
  type = list(object({
    port                     = string
    cidr_block               = list(string)
    source_security_group_id = string
  }))
  default = []
}
