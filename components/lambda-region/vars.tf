variable "name" {
  description = "Name of the Lambda Function"
}

variable "description" {
  description = "Description of what the Lambda Function does"
}

variable "create_s3_artifact_bucket" {
  type        = bool
  default     = false
  description = "Create S3 artifact bucket"
}

variable "s3_artifact_bucket" {
  description = "Name of the S3 bucket to upload versioned artifacts to"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources that support them"
  default     = {}
}

variable "lambda_code_source_dir" {
  description = "An absolute path to the directory containing the code to upload to lambda"
}

variable "file_globs" {
  type        = list(string)
  default     = ["index.js", "yarn.lock", "package-lock.json", "package.json"]
  description = "list of files or globs that you want included from the lambda_code_source_dir"
}

variable "local_file_dir" {
  description = "A path to the directory to store plan time generated local files"
  default     = "."
}

variable "runtime" {
  description = "The runtime of the lambda function"
  default     = "nodejs14.x"
}

variable "handler" {
  description = "The path to the main method that should handle the incoming requests"
  default     = "index.handler"
}

variable "config_file_name" {
  description = "The name of the file var.plaintext_params will be written to as json"
  default     = "config.json"
}


variable "function_env" {
  type = map(any)
  default = {
  }
}

variable "custom_policy_documents" {
  type     = list(string)
  nullable = true
  default  = []
}

variable "managed_policy_arns" {
  type     = list(string)
  nullable = true
  default  = []
}
