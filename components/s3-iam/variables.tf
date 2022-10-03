variable "bucket_name" {
  type = string
}

variable "bucket_iam_user_name" {
  type = string
}

variable "use_lambda_trigger" {
  type        = bool
  default     = false
  description = "trigger lambda function when an event occuss on bucket"
}

variable "lambda_function_config_list" {
  type = list(object({
    lambda_function_arn = string
    events              = list(string)
    filter_prefix       = string
    filter_suffix       = string
  }))
  description = "config lamdba trigger for this bucket, refer at https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification"
}

variable "tags" {
  type = map(any)
  default = {
  }
}
