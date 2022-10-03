variable "project" {
  type = string
}

variable "name" {
  type = string
}

variable "s3_artifact_bucket" {
  type = string
}

variable "create_s3_artifact_bucket" {
  type        = bool
  default     = false
  description = "Create S3 artifact bucket"
}
