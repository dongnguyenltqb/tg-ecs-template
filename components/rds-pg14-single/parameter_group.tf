resource "aws_db_parameter_group" "this" {
  name     = format("%s-parameter-group", var.name)
  family   = "postgres14"
  tags     = merge(local.tags, var.tags)
  tags_all = merge(local.tags, var.tags)
}
