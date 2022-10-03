variable "vpc_id" {
  type = string
}

variable "region" {
  type = string
}

variable "subnets" {
  type        = list(string)
  description = "require at least 2 subnets"
}

variable "cluster_name" {
  type = string
}

variable "tags" {
  type = map(any)
}
