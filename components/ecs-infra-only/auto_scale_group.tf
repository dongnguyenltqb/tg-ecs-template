resource "aws_launch_template" "asg" {
  name          = format("%sEcsEc2AsgLaunchTemplate", var.cluster_name)
  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = "t3a.small"

  vpc_security_group_ids = [aws_security_group.ec2_group.id]

  // register instance to ecs
  user_data = base64encode(format(<<EOT
  #!/bin/bash
  echo ECS_CLUSTER=%s >> /etc/ecs/ecs.config
  echo ECS_IMAGE_PULL_BEHAVIOR=always >> /etc/ecs/ecs.config
EOT
  , var.cluster_name))
  iam_instance_profile {
    // only use name or arn
    # name = aws_iam_instance_profile.ecs.name
    arn = aws_iam_instance_profile.ecs.arn
  }
  monitoring {
    enabled = true
  }
  // block_device_mappings is for additional bock devices.
  // to change default setting 
  // we need to know device name for given ami
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 35
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }
  tags     = merge(local.tags, var.tags)
  tags_all = merge(local.tags, var.tags)
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = format("Ec2FromEscAsg%s", var.cluster_name)
    }
  }
}

resource "aws_autoscaling_group" "group" {
  name_prefix           = format("%s-", var.cluster_name)
  vpc_zone_identifier   = var.subnets
  health_check_type     = "ELB"
  desired_capacity      = 1
  max_size              = 1
  min_size              = 1
  protect_from_scale_in = true
  force_delete          = true
  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  launch_template {
    name    = aws_launch_template.asg.name
    version = "$Latest"
  }
  lifecycle {
    ignore_changes = [desired_capacity, max_size, min_size]
  }
}


// Use AMI LINUX 2
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}

