# resource "aws_ecs_service" "fe" {
#   name                               = var.fe_service_name
#   cluster                            = aws_ecs_cluster.cluster.id
#   task_definition                    = aws_ecs_task_definition.fe.arn
#   launch_type                        = "FARGATE"
#   desired_count                      = 1
#   deployment_minimum_healthy_percent = 0
#   deployment_maximum_percent         = 100
#   force_new_deployment               = true

#   network_configuration {
#     subnets          = var.subnets
#     assign_public_ip = false
#     security_groups  = [aws_security_group.svc.id]
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.fe.arn
#     container_name   = var.container_name
#     container_port   = var.container_port
#   }
# }

// Service back-end api
resource "aws_ecs_service" "be" {
  depends_on = [
    aws_lb_target_group.be
  ]
  name                               = var.be_service_name
  cluster                            = aws_ecs_cluster.cluster.id
  task_definition                    = aws_ecs_task_definition.be.arn
  launch_type                        = "EC2"
  desired_count                      = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 500
  force_new_deployment               = true
  wait_for_steady_state              = false
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.be.arn
    container_name   = var.container_name
    container_port   = var.be_container_port
  }
}


// Service task scaling
resource "aws_appautoscaling_target" "be_task" {
  depends_on = [
    aws_ecs_cluster.cluster
  ]
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = format("service/%s/%s", var.cluster_name, var.be_service_name)
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_be_task_policy" {
  depends_on = [
    aws_appautoscaling_target.be_task
  ]
  name               = "Number of active connections to targets from the load balancer divided by number of target, metrics in 1 min."
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.be_task.resource_id
  scalable_dimension = aws_appautoscaling_target.be_task.scalable_dimension
  service_namespace  = aws_appautoscaling_target.be_task.service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = format("%s/%s", aws_lb.svc.arn_suffix, aws_lb_target_group.be.arn_suffix)
    }
    target_value       = 200
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

