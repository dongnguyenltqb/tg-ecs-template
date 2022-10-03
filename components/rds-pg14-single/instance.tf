resource "aws_db_instance" "this" {
  depends_on = [
    aws_db_subnet_group.this,
    aws_db_parameter_group.this,
    aws_security_group.this,
    aws_iam_role.this
  ]
  identifier_prefix = var.name
  engine            = "postgres"
  engine_version    = "14.4"
  instance_class    = "db.t3.micro"
  allocated_storage = 10
  db_name           = var.db_name
  username          = var.db_username
  password          = var.db_password

  port                   = 5432
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  availability_zone      = var.rds_availability_zones[0]
  parameter_group_name   = aws_db_parameter_group.this.name
  monitoring_role_arn    = aws_iam_role.this.arn
  monitoring_interval    = 5

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  publicly_accessible                   = false
  skip_final_snapshot                   = true
  backup_retention_period               = 7
  storage_encrypted                     = false
  storage_type                          = "standard"
  multi_az                              = false
  apply_immediately                     = true
  copy_tags_to_snapshot                 = true
  enabled_cloudwatch_logs_exports       = ["postgresql", "upgrade"]
  tags                                  = merge(local.tags, var.tags)
  tags_all                              = merge(local.tags, var.tags)
}
