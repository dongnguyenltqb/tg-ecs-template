variable "vpc_cidr" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "project" {
  type = string
}

variable "vpc_name" {
  type    = string
  default = null
}

variable "region" {
  type = string
}

# Peer connection
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

variable "peer_connection_name" {
  type    = string
  default = null
}

variable "peer_vpc_cidr" {
  type    = string
  default = null
}
