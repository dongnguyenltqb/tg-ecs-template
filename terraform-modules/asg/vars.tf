variable "ami_id" {
  type        = string
  description = "Docker-based AMI ID"
}

variable "instance_type" {
  type        = string
  description = "t3a.medium"
}

variable "iam_instance_profile" {
  description = "AM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  default     = "ec2-backend-role"
}

variable "ssh_key_name" {
  description = "SSH key to access the ec2 cluster"
  default     = "msi-production-ec2-bastion-ssh-key"
}

variable "ec2_security_group_ids" {
  type    = list(string)
  default = []
}

variable "user_data" {
  type    = string
  default = null
}

variable "project" {
  type        = string
  description = "Specify project name"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Specify the private subnet IDs from EC2 instances"
}

variable "alb_targetgroup_arns" {
  type        = list(string)
  default     = []
  description = "List of target group of ALB or NLB ARN which needs to be attached"
}

variable "min_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 6
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "enable_monitoring" {
  type    = bool
  default = false
}

variable "ebs_optimized" {
  type    = bool
  default = false
}
