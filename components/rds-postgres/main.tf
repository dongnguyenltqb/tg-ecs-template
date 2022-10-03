module "rds-postgresql" {
  source = "../../terraform-modules/rds-postgres"

  cluster_identifier = var.project
  identifier_prefix  = "${var.project}-"
  engine_version     = "12.10"
  master_dbname      = var.db_credentials.db_name
  master_username    = var.db_credentials.username
  master_password    = var.db_credentials.password

  region            = var.region
  availability_zone = element(data.aws_availability_zones.all.names, 0) # 1a

  private_subnets           = var.private_subnets
  source_security_group_ids = var.source_security_group_ids
  vpc_id                    = var.vpc_id

  instance_class        = "db.t3.medium"
  allocated_storage     = 20
  max_allocated_storage = 60

  backup_retention_period = 5
  skip_final_snapshot     = true

  environment = "Production"

  parameter_group_name   = var.parameter_group_name
  parameter_group_family = "postgres12"

  apply_immediately = true # need to be adjust in the stable production

  tags = merge(var.tags, {
    Name = "${var.project}-rds"
  })
}
