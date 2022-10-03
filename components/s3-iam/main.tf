resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_cors_configuration" "this" {
  depends_on = [
    aws_s3_bucket.this
  ]
  bucket = aws_s3_bucket.this.bucket
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
  }
}

resource "aws_iam_user" "this" {
  name = var.bucket_iam_user_name
  tags = var.tags
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

resource "aws_iam_policy" "this" {
  tags = var.tags
  name = "${var.bucket_name}-${var.bucket_iam_user_name}FullAccess"
  path = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = [aws_s3_bucket.this.arn, "${aws_s3_bucket.this.arn}/*"]
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "this" {
  name       = "${var.bucket_name}-${var.bucket_iam_user_name}PolicyAttachment"
  users      = [aws_iam_user.this.name]
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_lambda_permission" "allow_bucket" {
  count         = length(var.lambda_function_config_list)
  statement_id  = format("AllowExecutionFromS3Bucket-%s", count.index)
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_config_list[count.index].lambda_function_arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.this.arn

  depends_on = [
    aws_iam_user.this
  ]
}

resource "aws_s3_bucket_notification" "this" {
  count  = var.use_lambda_trigger ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "lambda_function" {
    for_each = var.lambda_function_config_list
    content {
      lambda_function_arn = lambda_function.value["lambda_function_arn"]
      events              = lambda_function.value["events"]
      filter_prefix       = lambda_function.value["filter_prefix"]
      filter_suffix       = lambda_function.value["filter_suffix"]
    }
  }
  depends_on = [
    aws_lambda_permission.allow_bucket
  ]
}

