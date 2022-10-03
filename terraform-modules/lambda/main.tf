data "archive_file" "zip_file_for_lambda" {
  type        = "zip"
  output_path = "${var.local_file_dir}/${var.name}.zip"

  dynamic "source" {
    for_each = distinct(flatten([
      for blob in var.file_globs :
      fileset(var.lambda_code_source_dir, blob)
    ]))
    content {
      content = try(
        file("${var.lambda_code_source_dir}/${source.value}"),
        filebase64("${var.lambda_code_source_dir}/${source.value}"),
      )
      filename = source.value
    }
  }

  # Optionally write a `config.json` file if any plaintext params were given
  dynamic "source" {
    for_each = length(keys(var.plaintext_params)) > 0 ? ["true"] : []
    content {
      content  = jsonencode(var.plaintext_params)
      filename = var.config_file_name
    }
  }
}

resource "aws_s3_bucket" "this" {
  count  = var.create_s3_artifact_bucket ? 1 : 0
  bucket = var.s3_artifact_bucket
}

# Upload the build artifact zip file to S3.
resource "aws_s3_bucket_object" "artifact" {
  depends_on = [
    aws_s3_bucket.this
  ]
  bucket = var.s3_artifact_bucket
  key    = "lambda/${var.name}.zip"
  source = data.archive_file.zip_file_for_lambda.output_path
  etag   = data.archive_file.zip_file_for_lambda.output_md5
  tags   = var.tags
}

resource "aws_lambda_function" "lambda" {
  function_name = var.name
  description   = var.description

  # Find the file from S3
  s3_bucket         = var.s3_artifact_bucket
  s3_key            = aws_s3_bucket_object.artifact.id
  s3_object_version = aws_s3_bucket_object.artifact.version_id
  source_code_hash  = filebase64sha256(data.archive_file.zip_file_for_lambda.output_path)

  publish = true
  handler = var.handler
  runtime = var.runtime
  role    = aws_iam_role.lambda_at_edge.arn
  tags    = var.tags

  lifecycle {
    ignore_changes = [
      last_modified,
    ]
  }
}

# policy to allow AWS to access this lambda function.
data "aws_iam_policy_document" "assume_role_policy_doc" {
  statement {
    sid     = "AllowAwsToAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "edgelambda.amazonaws.com",
        "lambda.amazonaws.com",
      ]
    }
  }
}

# also has permissions to write logs to CloudWatch.
resource "aws_iam_role" "lambda_at_edge" {
  name               = "${var.name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_doc.json
  tags               = var.tags
}

# allow lambda to write logs.
data "aws_iam_policy_document" "lambda_logs_policy_doc" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",

      # Lambda@Edge logs are logged into Log Groups in the region of the edge location
      # that executes the code. Because of this, we need to allow the lambda role to create
      # Log Groups in other regions
      "logs:CreateLogGroup",
    ]
  }
}

# attach the policy giving log write access to the IAM Role
resource "aws_iam_role_policy" "logs_role_policy" {
  name   = "${var.name}at-edge"
  role   = aws_iam_role.lambda_at_edge.id
  policy = data.aws_iam_policy_document.lambda_logs_policy_doc.json
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/lambda/${var.name}"
  tags = var.tags
}

# create the secret SSM parameters that can be fetched and decrypted by the lambda function.
resource "aws_ssm_parameter" "params" {
  for_each = var.ssm_params

  description = "param ${each.key} for the lambda function ${var.name}"

  name  = each.key
  value = each.value

  type = "SecureString"
  tier = length(each.value) > 4096 ? "Advanced" : "Standard"

  tags = var.tags
}

# create an IAM policy document giving access to read and fetch the SSM params
data "aws_iam_policy_document" "secret_access_policy_doc" {
  count = length(var.ssm_params) > 0 ? 1 : 0

  statement {
    sid    = "AccessParams"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "secretsmanager:GetSecretValue",
    ]
    resources = [
      for name, outputs in aws_ssm_parameter.params :
      outputs.arn
    ]
  }
}

# create a policy from the SSM policy document
resource "aws_iam_policy" "ssm_policy" {
  count = length(var.ssm_params) > 0 ? 1 : 0

  name        = "${var.name}-ssm-policy"
  description = "Gives the lambda ${var.name} access to params from SSM"
  policy      = data.aws_iam_policy_document.secret_access_policy_doc[0].json
}

# attach the policy giving SSM param access to the Lambda IAM Role
resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  count = length(var.ssm_params) > 0 ? 1 : 0

  role       = aws_iam_role.lambda_at_edge.id
  policy_arn = aws_iam_policy.ssm_policy[0].arn
}
