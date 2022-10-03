variable "project" {
  type     = string
  nullable = false
}

variable "tags" {
  type = map(any)
  default = {
  }
  nullable = false
}

variable "role_name" {
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
