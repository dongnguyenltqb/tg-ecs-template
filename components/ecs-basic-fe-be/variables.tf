variable "region" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "fe_service_name" {
  type = string
}

variable "be_service_name" {
  type = string
}

variable "fe_task_definition_family" {
  type = string
}

variable "be_task_definition_family" {
  type = string
}

variable "image_url" {
  type = string
}

variable "container_name" {
  type = string
}

variable "fe_container_port" {
  type = number
}

variable "be_container_port" {
  type = number
}

variable "secrets" {
  type = map(string)
}
