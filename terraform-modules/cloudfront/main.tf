module "cloudfront-s3-cdn" {
  source  = "cloudposse/cloudfront-s3-cdn/aws"

  name               = var.name
//  origin_bucket      = var.existing_bucket_name
  price_class        = "PriceClass_200"
//  custom_origin_headers = var.custom_origin_headers
  encryption_enabled = true

  # Caching Settings
  default_ttl = 300
  compress    = true

  # Website settings
  website_enabled = true
  index_document  = "index.html"
  error_document  = "index.html"

  custom_origins = [

  ]
  # Lambda@Edge setup
  lambda_function_association = [{
    event_type   = "origin-request"
    include_body = false
    lambda_arn   = var.lambda_arn
  }]
}
