resource "aws_ecs_service" "this" {
  name                               = var.service_name
  cluster                            = var.cluster_id
  task_definition                    = aws_ecs_task_definition.this.arn
  launch_type                        = "EC2"
  desired_count                      = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 500
  force_new_deployment               = true
  wait_for_steady_state              = true
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
  tags = merge(local.tags, var.tags, {
    Name = var.service_name
  })
}
