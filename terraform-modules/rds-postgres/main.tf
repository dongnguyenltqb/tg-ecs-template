resource "aws_db_parameter_group" "rds_postgres_pg" {
  name        = var.parameter_group_name != null ? var.parameter_group_name : "${var.cluster_identifier}-parameter-group"
  family      = var.parameter_group_family
  description = "RDS parameters group"
  parameter {
    name  = "log_statement"
    value = var.param_log_statement
  }
  parameter {
    name  = "log_min_duration_statement"
    value = var.param_log_min_duration_statement
  }
  tags = var.tags
}

resource "aws_db_subnet_group" "main" {
  name        = "${var.cluster_identifier}-subnet-group"
  description = "${var.cluster_identifier}-subnet-group"
  subnet_ids  = var.private_subnets
  tags        = var.tags
}

resource "aws_db_instance" "rds_postgres" {
  identifier_prefix     = var.identifier_prefix
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = true

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class
  name           = var.master_dbname
  username       = var.master_username
  password       = var.master_password
  port           = var.allowed_port

  vpc_security_group_ids = [aws_security_group.security_group_rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  availability_zone      = var.availability_zone
  multi_az               = var.multi_az || false
  publicly_accessible    = false # strictly prevent in production env

  parameter_group_name            = aws_db_parameter_group.rds_postgres_pg.name
  maintenance_window              = var.maintenance_window
  backup_window                   = var.backup_window
  backup_retention_period         = var.backup_retention_period
  skip_final_snapshot             = var.skip_final_snapshot
  apply_immediately               = var.apply_immediately
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports ? ["postgresql", "upgrade"] : []

  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  deletion_protection                   = var.environment == "Production" ? true : false
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  lifecycle {
    ignore_changes = [
      availability_zone,
      password
    ]
  }

  tags = var.tags
}
