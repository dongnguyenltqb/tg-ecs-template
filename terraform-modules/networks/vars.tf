variable "aws_region" {
  type        = string
  description = "AWS region which should be used"
}

variable "aws_zones" {
  type        = list(any)
  description = "AWS AZs (Availability zones) where subnets should be created"
}

# Private subnets
variable "private_subnets" {
  description = "Create both private and public subnets"
  type        = bool
  default     = false
}

variable "create_nat" {
  type        = bool
  default     = false
  description = "Create NAT gateway for private subnet"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

# Network details (Change this only if you know what you are doing or if you think you are lucky)
variable "vpc_cidr" {
  type        = string
  description = "CIDR of the VPC"
}

variable "tags" {
  description = "Different tag values which should be assigned to AWS resources created via Terraform)"
  type        = map(any)
}

# Peer connection
variable "peer_connection_name" {
  type    = string
  default = null
}
variable "create_peer_connection" {
  type    = bool
  default = false
}

variable "peer_vpc_id" {
  type    = string
  default = null

}

variable "peer_vpc_owner_id" {
  type    = string
  default = null
}

variable "peer_vpc_cidr" {
  type    = string
  default = null
}
