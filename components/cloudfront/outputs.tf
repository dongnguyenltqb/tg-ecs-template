output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.this.id
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_arn" {
  value = aws_cloudfront_distribution.this.arn
}

output "cloudfront_oai_iam" {
  value = aws_cloudfront_origin_access_identity.s3.iam_arn
}
