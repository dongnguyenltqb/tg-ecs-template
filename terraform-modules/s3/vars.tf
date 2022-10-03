variable "bucket_name" {
  description = "S3 bucket name"
}

variable "bucket_enable_versioning" {
  description = "Enable the bucket versioning"
  default = false
}

variable "env" {
  type = string
  description = "Specify the environment"
}
