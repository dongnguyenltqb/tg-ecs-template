output "iam_user_name" {
  value = aws_iam_user.this.name
}

output "iam_user_arn" {
  value = aws_iam_user.this.arn
}

output "iam_access_key_id" {
  value     = aws_iam_access_key.this.id
  sensitive = false
}

output "iam_secret_access_key_id" {
  value = nonsensitive(aws_iam_access_key.this.secret)
}
