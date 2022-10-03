variable "vpc_id" {
  type = string
}
variable "project" {
  type    = string
  default = "msi"
}
variable "env" {
  type    = string
  default = "production"
}
variable "subnets" {
  type    = list(string)
  default = []
}
variable "azs" {
  type        = list(string)
  description = "List of availability zones"
}
variable "ingress_ports" {
  type        = list(number)
  description = "List of ingress ports to be opened"
  default     = [80, 443]
}
variable "dns_zone" {
  type = string
}
variable "alb_idle_timeout" {
  type    = number
  default = 2000
}
variable "target_groups" {
  type = map(any)
  default = {
    "alb-targetgroup" = {
      port = 80
      health_check = {
        endpoint = "/"
        interval = 120
      }
    }
  }
}
