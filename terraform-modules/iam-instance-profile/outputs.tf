output "profile_arn" {
  value = aws_iam_instance_profile.this.arn
}

output "profile_name" {
  value = aws_iam_instance_profile.this.name
}
