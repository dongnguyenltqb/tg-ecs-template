output "host" {
  value = aws_rds_cluster_instance.instances.*.endpoint
}

output "arn" {
  value = aws_rds_cluster_instance.instances.*.arn
}
