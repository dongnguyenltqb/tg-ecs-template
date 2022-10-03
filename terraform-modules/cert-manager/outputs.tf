output "cert_arn" {
  value = aws_acm_certificate.this.arn
}
output "hosted_zone_id" {
  value = data.aws_route53_zone.this.id
}
