resource "aws_db_subnet_group" "this" {
  name       = var.name
  subnet_ids = var.rds_subnets
  tags       = merge(local.tags, var.tags)
}
