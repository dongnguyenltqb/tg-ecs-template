# ALB DNS is generated dynamically, return URL so that it can be used
output "url" {
  value = "http://${aws_alb.main.dns_name}/"
}

//output "testing" {
//  value = "Test this demo code by going to https://${aws_route53_record.main.fqdn} and checking your have a valid SSL cert"
//}

output "zone_id" {
  value = aws_alb.main.zone_id
}

output "dns_name" {
  value = aws_alb.main.dns_name
}

output "target_group_arns" {
  value = [
    for tg in aws_alb_target_group.main : tg.arn
  ]
}
