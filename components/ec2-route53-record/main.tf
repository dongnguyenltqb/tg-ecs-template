resource "aws_route53_record" "this" {
  zone_id         = data.aws_route53_zone.this.id
  name            = var.domain_name
  type            = var.record_type
  ttl             = "300"
  records         = [var.domain_value]
  allow_overwrite = false
}

data "aws_route53_zone" "this" {
  name         = var.hosted_zone_domain_name
  private_zone = false
}
