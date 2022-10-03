# creating launch configuration
resource "aws_launch_configuration" "main" {
  image_id             = var.ami_id
  instance_type        = var.instance_type
  security_groups      = var.ec2_security_group_ids
  iam_instance_profile = var.iam_instance_profile
  user_data            = var.user_data
  enable_monitoring    = var.enable_monitoring
  ebs_optimized        = var.ebs_optimized
  key_name             = var.ssh_key_name
  lifecycle {
    create_before_destroy = true
  }
}

# creating auto-scaling group
resource "aws_autoscaling_group" "main" {
  name                 = "${var.project}-asg"
  launch_configuration = aws_launch_configuration.main.id
  vpc_zone_identifier  = var.subnet_ids #["${aws_subnet.private.*.id}"]

  desired_capacity = var.desired_size
  max_size         = var.max_size
  min_size         = var.min_size

  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "${var.project}-autoscaling-group"
    propagate_at_launch = true
  }
  tag {
    key                 = "Application"
    propagate_at_launch = false
    value               = "sp-provisioner"
  }

  lifecycle {
    ignore_changes = [
      target_group_arns
    ]
  }
}

# attach the target group to autoscaling
resource "aws_autoscaling_attachment" "main" {
  count                  = length(var.alb_targetgroup_arns)
  alb_target_group_arn   = var.alb_targetgroup_arns[count.index]
  autoscaling_group_name = aws_autoscaling_group.main.id
}
