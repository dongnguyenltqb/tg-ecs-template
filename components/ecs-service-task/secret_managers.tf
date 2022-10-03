// Secret
resource "aws_secretsmanager_secret" "this" {
  name = format("%s%sSecret", var.cluster_name, var.task_family)
}

resource "aws_secretsmanager_secret_version" "version" {
  version_stages = ["AWSCURRENT"]
  secret_id      = aws_secretsmanager_secret.this.id
  secret_string  = jsonencode(var.secrets)
}
