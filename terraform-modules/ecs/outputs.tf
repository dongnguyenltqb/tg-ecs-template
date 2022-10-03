output "ecs_cluster_id" {
  description = "ID of the ECS Cluster"
  value       = concat(aws_ecs_cluster.main.*.id, [""])[0]
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS Cluster"
  value       = concat(aws_ecs_cluster.main.*.arn, [""])[0]
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = var.name
}
