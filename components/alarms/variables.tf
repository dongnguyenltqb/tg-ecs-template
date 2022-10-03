variable "ec2_instances" {
  type = list(object({
    name        = string
    instance_id = string
    threshold   = string
    period      = string
  }))
  default = []
}

variable "nlb_unhealthyhosts" {
  type = list(object({
    name                    = string
    target_group_arn_suffix = string
  }))
  default = []
}

variable "tags" {
  type = map(any)
  default = {
  }
}
