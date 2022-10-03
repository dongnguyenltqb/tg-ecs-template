# scale up alarm
resource "aws_autoscaling_policy" "cpu-policy" {
  name = "${var.project}-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.main.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "1"
  cooldown = "300"
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu-alarm" {
  alarm_name = "${var.project}-cpu-alarm"
  alarm_description = "${var.project}-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "60"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.main.name
  }
  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.cpu-policy.arn]
}

# scale down alarm
resource "aws_autoscaling_policy" "cpu-policy-scaledown" {
  name = "${var.project}-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.main.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "-1"
  cooldown = "300"
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu-alarm-scaledown" {
  alarm_name = "${var.project}-cpu-alarm-scaledown"
  alarm_description = "${var.project}-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "50"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.main.name
  }
  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.cpu-policy-scaledown.arn]
}
