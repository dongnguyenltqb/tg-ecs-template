resource "aws_cloudfront_origin_access_identity" "s3" {
  comment = "access-identity-${var.s3_gigabyte_domain_name}"
}

resource "aws_cloudfront_distribution" "this" {
  comment             = var.description
  wait_for_deployment = false
  origin {
    domain_name = var.s3_gigabyte_domain_name
    origin_id   = var.s3_gigabyte_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.s3.cloudfront_access_identity_path
    }
    custom_header {
      name  = "JWT_SECRET_KEY"
      value = var.gigabyte_origin_jwt_secret_key
    }
  }
  origin {
    domain_name = var.msi_elb
    origin_id   = var.msi_elb_origin_id
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1.1", "TLSv1.2", "SSLv3"]
    }
  }
  origin {
    domain_name = var.s3_frontend_website_url
    origin_id   = var.s3_frontend_origin_id
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = "index.html"
  aliases             = var.domain_names
  price_class         = "PriceClass_200"
  tags                = var.tags

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = var.cert_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
  // custom error
  # custom_error_response {
  #   error_code         = 403
  #   response_code      = 200
  #   response_page_path = "/index.html"
  # }
  // front end 
  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.s3_frontend_origin_id
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      headers      = ["Origin", "Access-Control-Request-Method", "Access-Control-Request-Header"]
      cookies {
        forward = "none"
      }
    }
    min_ttl     = 0
    default_ttl = 300
    max_ttl     = 31536000
  }
  // blogs request
  ordered_cache_behavior {
    path_pattern               = "/blogs/*"
    allowed_methods            = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods             = ["GET", "HEAD"]
    target_origin_id           = var.s3_gigabyte_origin_id
    compress                   = true
    response_headers_policy_id = "293febc0-e82b-4af0-a8fa-7e7049921891"
    forwarded_values {
      query_string            = true
      query_string_cache_keys = ["ver"]
      cookies {
        forward = "all"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = var.gigabyte_lambda_function_arn
      include_body = false
    }
    # lambda_function_association {
    #   event_type = "viewer-response"
    #   lambda_arn = var.gigabyte_lambda_viewer_response_function_arn
    # }
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 31536000
  }
  // back end
  ordered_cache_behavior {
    path_pattern           = "/api/*"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.msi_elb_origin_id
    viewer_protocol_policy = "redirect-to-https"
    // disable cache
    forwarded_values {
      query_string = true
      headers      = ["*"]
      cookies {
        forward = "all"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  depends_on = [
    aws_cloudfront_origin_access_identity.s3,
    aws_cloudfront_distribution.this
  ]
  bucket = var.s3_gigabyte_bucket_id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  depends_on = [
    aws_cloudfront_origin_access_identity.s3,
    aws_cloudfront_distribution.this
  ]
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.s3.iam_arn]
    }
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "arn:aws:s3:::${var.s3_gigabyte_bucket_id}/*"
    ]
  }
}
