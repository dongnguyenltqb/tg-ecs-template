variable "user" {
  type        = string
  description = "user name for the ssh connection"
}

variable "private_key" {
  type        = string
  description = "private key use to connect to host"
}

variable "host" {
  type        = string
  description = "host address or ip"
}

variable "contents" {
  type = list(object({
    source            = string
    destination       = string
    create_dir        = string
    before_inline_cmd = string
    after_inline_cmd  = string
  }))
  description = "a list of file to upload to server"
  default     = []
}

# variable "destroy_cmd" {
#   type    = string
#   default = null
# }
