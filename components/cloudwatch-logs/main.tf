resource "aws_cloudwatch_log_group" "this" {
  name = var.log_group_name
  tags = var.tags
}
