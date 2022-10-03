output "nlb_endpoint" {
  value = aws_lb.this.dns_name
}

output "nlb_target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "nlb_target_group_arn_suffix" {
  value = aws_lb_target_group.this.arn_suffix
}

output "nlb_plaintext_target_group_arn" {
  value = aws_lb_target_group.plaintext.arn
}

output "nlb_plaintext_target_group_arn_suffix" {
  value = aws_lb_target_group.plaintext.arn_suffix
}

