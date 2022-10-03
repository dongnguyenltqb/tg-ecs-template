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

  environment {
    variables = var.function_env
  }

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

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/lambda/${var.name}"
  tags = var.tags
}

# attach custom policy
resource "aws_iam_policy" "this" {
  count  = length(var.custom_policy_documents)
  name   = format("%sIamCustomPolicy%s", var.name, count.index)
  policy = var.custom_policy_documents[count.index]
  tags   = var.tags
}

resource "aws_iam_policy_attachment" "custom" {
  depends_on = [
    aws_iam_role.lambda_at_edge,
  ]
  count      = length(var.custom_policy_documents)
  name       = format("%sRoleCustomPolicy%sAttachment", var.name, count.index)
  policy_arn = aws_iam_policy.this[count.index].arn
  roles      = [aws_iam_role.lambda_at_edge.name]
}

resource "aws_iam_policy_attachment" "aws_managed" {
  depends_on = [
    aws_iam_role.lambda_at_edge,
  ]
  count      = length(var.managed_policy_arns)
  name       = format("%sRoleManagedPolicy%sAttachment", var.name, count.index)
  policy_arn = var.managed_policy_arns[count.index]
  roles      = [aws_iam_role.lambda_at_edge.name]
}


