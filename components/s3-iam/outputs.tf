output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}
output "bucket_id" {
  value = aws_s3_bucket.this.id
}
output "bucket_iam_access_key" {
  value = aws_iam_access_key.this.id
}

output "bucket_iam_secret_key" {
  value = nonsensitive(aws_iam_access_key.this.secret)
}

output "bucket_domain_name" {
  value = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.this.bucket_regional_domain_name
}
