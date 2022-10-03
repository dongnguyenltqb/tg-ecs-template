# get all available AZs in our region
data "aws_availability_zones" "available_azs" {
  state = "available"
  exclude_names = var.exclude_availability_zones
}

# reserve elastic IP addresses for NAT gateways
# we might want to keep these static for third party whitelists like the ec2 instances cluster
//resource "aws_eip" "nat" {
//  count = 2 # for public - private + database subnets
//  vpc   = true
//
//  tags = {
//    Name            = "${var.project_name}-nat-eip"
//    iac_environment = var.iac_environment_tag
//  }
//}

# create VPC using the official AWS module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  name = "${var.name_prefix}-vpc"
  cidr = var.main_network_block
  azs  = data.aws_availability_zones.available_azs.names

  # 172.17.0.0/16
  private_subnets = [
    # this loop will create a one-line list as ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20", ...]
    # with a length depending on how many AZs are available
    for zone_id in data.aws_availability_zones.available_azs.zone_ids :
    cidrsubnet(var.main_network_block, var.subnet_prefix_extension, tonumber(substr(zone_id, length(zone_id) - 1, 1)) - 1)
  ]

  public_subnets = [
    # this loop will create a one-line list as ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20", ...]
    # with a length depending on how many AZs are available
    # there is a zone offset variable, to make sure no collisions are present with private subnets
    for zone_id in data.aws_availability_zones.available_azs.zone_ids :
    cidrsubnet(var.main_network_block, var.subnet_prefix_extension, tonumber(substr(zone_id, length(zone_id) - 1, 1)) + var.zone_offset - 1)
  ]

  # database
  database_subnets = [
    # this loop will create a one-line list as ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20", ...]
    # with a length depending on how many AZs are available
    # there is a zone offset variable, to make sure no collisions are present with private subnets
    for zone_id in data.aws_availability_zones.available_azs.zone_ids :
    cidrsubnet(var.main_network_block, var.subnet_prefix_extension, tonumber(substr(zone_id, length(zone_id) - 1, 1)) + (var.zone_offset * 2) - 1)
  ]

  # create a NAT gateway
  enable_nat_gateway     = true
  single_nat_gateway     = true
//  one_nat_gateway_per_az = false
//  enable_dns_hostnames   = true
//  reuse_nat_ips          = true             # skip creation of EIPs
//  external_nat_ip_ids    = aws_eip.nat.*.id # assign previously created EIPs

  tags = {
    name            = var.project_name
    iac_environment = var.iac_environment_tag
  }
  public_subnet_tags = {
    name            = var.project_name
    iac_environment = var.iac_environment_tag
  }
  private_subnet_tags = {
    name            = var.project_name
    iac_environment = var.iac_environment_tag
  }
}
