include "dev" {
  path = find_in_parent_folders("dev.hcl")
}

include "root" {
  path = "${dirname("../../")}/terragrunt.hcl"
}

terraform {
  source = "../../../components//network"
}


inputs = {
  project = "ET"
  tags = {
    Environment = "Dev"
    Component   = "VPC"
  }
  vpc_cidr               = "10.12.0.0/16"
  region                 = "ap-southeast-1"
  private_subnets        = true
  create_nat             = false
  create_peer_connection = false
}