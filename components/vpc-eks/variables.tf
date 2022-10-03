variable "aws_region" {
  default  = "ap-southeast-1"
  nullable = false
}

variable "cluster_name" {
  type = string
}

variable "jump_server_profile_role_name" {
  type = string
}

variable "tags" {
  type = map(any)
  default = {
  }
}

variable "jump_pubkey" {
  type = string
}
