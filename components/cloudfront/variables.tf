variable "description" {
  type = string
}

variable "domain_names" {
  type    = list(string)
  default = null
}

variable "s3_gigabyte_bucket_id" {
  type = string
}

variable "s3_gigabyte_origin_id" {
  type = string
}

variable "s3_gigabyte_domain_name" {
  type = string
}
variable "gigabyte_origin_jwt_secret_key" {
  type = string
}

variable "gigabyte_lambda_function_arn" {
  type = string
}

variable "gigabyte_lambda_viewer_response_function_arn" {
  type    = string
  default = true
}

variable "msi_elb" {
  type = string
}

variable "msi_elb_origin_id" {
  type = string
}

variable "s3_frontend_bucket_id" {
  type = string
}

variable "s3_frontend_domain_name" {
  type = string
}

variable "s3_frontend_website_url" {
  type = string
}

variable "s3_frontend_origin_id" {
  type = string
}

variable "cert_arn" {
  type = string
}

variable "tags" {
  type = map(any)
  default = {
  }
}
