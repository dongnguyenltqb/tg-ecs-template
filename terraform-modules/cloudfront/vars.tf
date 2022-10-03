variable "name" {
  type = string
}
variable "lambda_arn" {
  type = string
  description = "Lambda ARN which needs to be attached as the Lambda Edge"
  default = null
}
variable "custom_origin_headers" {
  type = list(object({
    name = string
    value = string
  }))
  default = []
}
