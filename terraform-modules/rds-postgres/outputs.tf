output "rds_postgres_pg_id" {
  value       = aws_db_parameter_group.rds_postgres_pg.id
  description = "ID of the RDS postgres parameter group"
}

output "rds_postgres_id" {
  value       = aws_db_instance.rds_postgres.id
  description = "ID of the of the RDS instance"
}

output "rds_security_group_ids" {
  value       = [aws_security_group.security_group_rds.id]
  description = "List of security group ids attached to the rds instance"
}

output "rds_hostname" {
  value = aws_db_instance.rds_postgres.address
}

output "rds_db_port" {
  value = aws_db_instance.rds_postgres.port
}

output "rds_username" {
  value = aws_db_instance.rds_postgres.username
}

output "rds_dbname" {
  value = aws_db_instance.rds_postgres.name
}

output "cloudwatch_logs_path" {
  value = (
  var.enabled_cloudwatch_logs_exports ?
  format("/aws/rds/instance/%s/postgresql", aws_db_instance.rds_postgres.id)
  : ""
  )
}
