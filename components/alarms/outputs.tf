output "ec2_arn" {
  value = aws_cloudwatch_metric_alarm.ec2[*].arn
}
output "nlb_target_group_healthcheck_arn" {
  value = aws_cloudwatch_metric_alarm.nlb_unhealthyhosts[*].arn
}

