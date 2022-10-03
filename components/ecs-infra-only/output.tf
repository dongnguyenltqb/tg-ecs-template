output "alb_dns_name" {
  value = aws_lb.svc.dns_name
}

output "ecs_instance_role_arn" {
  value = aws_iam_role.ec2_instances.arn
}

output "ami_id" {
  value = data.aws_ami.amazon-linux-2.id
}

output "ec2_asg_sg" {
  value = aws_security_group.ec2_group.arn
}

output "ec2_asg_launch_template" {
  value = aws_launch_template.asg.arn
}
