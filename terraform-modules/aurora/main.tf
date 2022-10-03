resource "aws_rds_cluster" "main" {
  cluster_identifier      = var.cluster_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  engine_mode             = var.engine_mode
  availability_zones      = var.availability_zones
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  skip_final_snapshot     = var.skip_final_snapshot
  apply_immediately       = var.apply_immediately
  deletion_protection     = var.deletion_protection
  db_subnet_group_name    = var.db_subnet_group_name
  vpc_security_group_ids  = [aws_security_group.security_group_rds.id]
  #final_snapshot_identifier = "${var.cluster_identifier}-${var.database_name}"
  tags = var.tags
}

resource "aws_rds_cluster_instance" "instances" {
  count                = var.number_of_instances
  identifier           = "${var.cluster_identifier}-${count.index}"
  cluster_identifier   = aws_rds_cluster.main.id
  instance_class       = var.instance_size
  engine               = aws_rds_cluster.main.engine
  engine_version       = aws_rds_cluster.main.engine_version
  db_subnet_group_name = var.db_subnet_group_name
  tags                 = var.tags
}
