output "cluster_id" {
  description = "Aurora cluster identifier"
  value       = aws_rds_cluster.main.id
}
output "cluster_arn" {
  description = "ARN of Aurora cluster"
  value       = aws_rds_cluster.main.arn
}
output "cluster_endpoint" {
  description = "Endpoint of Aurora cluster"
  value       = aws_rds_cluster.main.endpoint
}
output "reader_endpoint" {
  description = "Reader endpoint of Aurora cluster"
  value       = aws_rds_cluster.main.reader_endpoint
}
output "cluster_port" {
  description = "Aurora cluster port"
  value       = aws_rds_cluster.main.port
}
output "cluster_db_name" {
  description = "Aurora Mysql database name"
  value       = var.database_name
}
