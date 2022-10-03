resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
  tags = merge(local.tags, var.tags, {
    name = var.cluster_name
  })
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

// cluster capacity provider
resource "aws_ecs_cluster_capacity_providers" "provider" {
  depends_on = [
    aws_ecs_capacity_provider.ec2
  ]
  cluster_name       = aws_ecs_cluster.cluster.name
  capacity_providers = ["FARGATE", aws_ecs_capacity_provider.ec2.name]
  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

// EC2 provider, use resource from EC2-ASG
resource "aws_ecs_capacity_provider" "ec2" {
  name = format("%sEC2Provider", var.cluster_name)
  depends_on = [
    aws_autoscaling_group.group
  ]
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.group.arn
    managed_termination_protection = "ENABLED"
    // manage auto scaling
    // https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-auto-scaling.html
    managed_scaling {
      maximum_scaling_step_size = 10
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 99
    }
  }
  tags = merge(local.tags, var.tags)
}

