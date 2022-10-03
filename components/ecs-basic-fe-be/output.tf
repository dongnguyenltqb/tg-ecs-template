output "alb_dns_name" {
  value = aws_lb.svc.dns_name
}
output "fe_task_definition_arn" {
  value = aws_ecs_task_definition.fe.arn
}

output "be_task_definition_arn" {
  value = aws_ecs_task_definition.be.arn
}

output "image_url" {
  value = var.image_url
}

output "execution_task_role_arn" {
  value = aws_iam_role.execution_task.arn
}

output "ecs_instance_role_arn" {
  value = aws_iam_role.ec2_instances.arn
}

output "ami_id" {
  value = data.aws_ami.amazon-linux-2.id
}
