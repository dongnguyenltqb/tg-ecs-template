variable "app_name" {
  type = string
}

variable "cluster_oidc_arn" {
  type     = string
  nullable = true
}

variable "cluster_oidc_url" {
  type     = string
  nullable = true
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

