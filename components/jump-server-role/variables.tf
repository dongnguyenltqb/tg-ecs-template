variable "tags" {
  type = map(any)
  default = {
  }
  nullable = false
}

variable "profile_name" {
  type = string
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
