resource "aws_rds_cluster" "main" {

  cluster_identifier      = var.cluster_identifier
  engine                  = "aurora-postgresql"
  engine_version          = var.engine_version
  engine_mode             = var.engine_mode
  availability_zones      = var.availability_zones

  port                = 5432
  master_username     = var.master_username
  master_password     = var.master_password
  database_name       = var.database_name
  apply_immediately   = var.apply_immediately
  deletion_protection = var.deletion_protection
  preferred_backup_window = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  vpc_security_group_ids  = [aws_security_group.security_group_rds.id]

  db_subnet_group_name    = aws_db_subnet_group.main.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.main.id

//  maintenance_window      = var.maintenance_window
//  backup_window           = var.backup_window
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  copy_tags_to_snapshot   = var.copy_tags_to_snapshot

//  scaling_configuration {
//    min_capacity = var.min_capacity
//    max_capacity = var.max_capacity
//    auto_pause   = var.auto_pause
//    seconds_until_auto_pause = var.seconds_until_auto_pause
//    timeout_action = "RollbackCapacityChange"
//  }
  #final_snapshot_identifier = "${var.cluster_identifier}-${var.database_name}"
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports ? ["postgresql"] : []
  tags = var.tags

  lifecycle {
    ignore_changes = [
      availability_zones, # for avoiding recreate with the new changing zones
      master_password
    ]
  }
}

resource "aws_rds_cluster_parameter_group" "main" {
  name        = "${var.cluster_identifier}-parameter-group"
  family      = "aurora-postgresql12"
  description = "${var.cluster_identifier}-parameter-group"
  tags        = var.tags
}

resource "aws_db_subnet_group" "main" {
  name        = "${var.cluster_identifier}-subnet-group"
  description = "${var.cluster_identifier}-subnet-group"
  subnet_ids  = var.private_subnets
  tags        = var.tags
}
