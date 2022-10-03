resource "aws_secretsmanager_secret" "this" {
  name = var.secret_name
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "current" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode(var.secret_value)
}
