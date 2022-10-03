output "vpc_id" {
  value = module.networks.vpc_id
}

output "vpc_cidr" {
  value = module.networks.vpc_cidr
}

output "public_subnets" {
  value = module.networks.subnet_ids
}

output "private_subnets" {
  value = module.networks.private_subnet_ids
}
