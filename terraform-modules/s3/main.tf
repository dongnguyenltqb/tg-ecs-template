resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name
  tags = {
    Name        = var.bucket_name
    Application = "msi"
    Environment = var.env
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  count  = var.bucket_enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = var.bucket_enable_versioning ? "Enabled" : "Disabled"
  }
}
