variable "bucket_name" {
  description = "S3 bucket name"
}

variable "dynamo_lock_name" {
  description = "DynamoDB lock table name"
}

variable "bucket_enable_versioning" {
  description = "Enable the bucket versioning"
  default = false
}

variable "aws_region" {
    description = "AWS region."
    default = "ap-northeast-1"
}
