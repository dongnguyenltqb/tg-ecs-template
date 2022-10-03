module "networks" {
  source                 = "../../terraform-modules/networks"
  aws_region             = var.region
  aws_zones              = data.aws_availability_zones.all.names
  tags                   = merge(local.tags, var.tags)
  vpc_cidr               = var.vpc_cidr
  vpc_name               = var.vpc_name != null ? var.vpc_name : var.project
  private_subnets        = true
  create_nat             = false
  create_peer_connection = var.create_peer_connection
  peer_vpc_owner_id      = var.peer_vpc_owner_id
  peer_vpc_id            = var.peer_vpc_id
  peer_connection_name   = var.peer_connection_name
  peer_vpc_cidr          = var.peer_vpc_cidr
}
