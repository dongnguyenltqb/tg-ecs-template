variable "name" {
  type        = string
  nullable    = false
  description = "iam username"
}

variable "tags" {
  type = map(any)
  default = {
  }
  nullable = false
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
