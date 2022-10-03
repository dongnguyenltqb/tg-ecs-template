resource "aws_cloudwatch_metric_alarm" "ec2" {
  count               = length(var.ec2_instances)
  alarm_name          = var.ec2_instances[count.index].name
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  datapoints_to_alarm = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.ec2_instances[count.index].period
  statistic           = "Average"
  threshold           = var.ec2_instances[count.index].threshold
  dimensions = {
    InstanceId = var.ec2_instances[count.index].instance_id
  }
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  tags                      = var.tags
}

resource "aws_cloudwatch_metric_alarm" "nlb_unhealthyhosts" {
  count               = length(var.nlb_unhealthyhosts)
  alarm_name          = var.nlb_unhealthyhosts[count.index].name
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/NetworkELB"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "Number of un healthy nodes in Target Group"
  dimensions = {
    TargetGroup = var.nlb_unhealthyhosts[count.index].target_group_arn_suffix
  }
}
