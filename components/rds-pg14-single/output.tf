output "rds_arn" {
  value = aws_db_instance.this.arn
}

output "rds_instance_endpoint" {
  value = aws_db_instance.this.endpoint
}
