variable "role_name" {
  type = string
}

variable "cluster_oidc_arn" {
  type = string
}

variable "cluster_oidc_url" {
  type = string
}

variable "service_account_name" {
  type = string
}

variable "service_account_namespace" {
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

variable "tags" {
  type = map(any)
  default = {
  }
  nullable = false
}
