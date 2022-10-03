variable "name" {
  type = string
  description = "Specify the name of the instance(s)"
}

variable "instances" {
  type = map(object({
    instance_type     = string
    subnet_id         = string
    root_block_device = list(any)
  }))
  description = "Specify single/multiple instances with `for_each`"
}

variable "ami" {
  description = "Set the AMI id for the instance(s)"
  type = string
}

variable "security_group_ids" {
  description = "List of security group rules for the instance(s)"
  type = list(string)
}

variable "iam_instance_profile" {
  description = "AM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  default = "ec2-backend-role"
}

variable "user_data" {
  type = string
  description = "The user data to provide when launching the instance."
  default = null
}

variable "tags" {
  description = "Tagging the AWS resources"
  type = map(string)
  default = {
    Owner       = "terraform"
    Environment = "staging"
  }
}

variable "enable_monitoring" {
  type = bool
  default = false
}

variable "ssh_key_name" {
  type = string
  default = null
}
