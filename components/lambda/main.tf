module "this" {
  source                    = "../../terraform-modules/lambda"
  description               = "${var.project} - Lambda@Edge at Cloudfront Distribution"
  name                      = var.name
  lambda_code_source_dir    = "${path.module}/source"
  runtime                   = "nodejs14.x"
  s3_artifact_bucket        = var.s3_artifact_bucket
  create_s3_artifact_bucket = var.create_s3_artifact_bucket
}
