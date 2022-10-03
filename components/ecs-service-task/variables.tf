variable "vpc_id" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "target_group_arn" {
  type = string
}


variable "container_name" {
  type = string
}
variable "container_port" {
  type = string
}

variable "task_family" {
  type = string
}

variable "secrets" {
  type = map(any)
  default = {
    Key = "Value"
  }
}

variable "tags" {
  type = map(string)
  default = {
  }
}
