variable "backup_retention_period" {
  description = "The number of days to retain backups for."
  type        = number
  default     = 1
}

variable "cluster_identifier" {
  description = "The name/identifier for the cluster."
  type        = string
}

variable "database_name" {
  description = "Name for an automatically created database"
  type        = string
}

//variable "db_subnet_group_name" {
//  description = "A DB subnet group to be used for the cluster"
//  type        = string
//}

variable "deletion_protection" {
  description = "Prevent deletion of the db cluster"
  type        = bool
  default     = false
}

variable "engine_version" {
  description = "DB engine version"
  type        = string
  default     = "12.6"
}

variable "engine_mode" {
  type = string
  default = "serverless"
}

variable "apply_immediately" {
  type = bool
  default = false
}

variable "master_password" {
  description = "Master password for cluster"
  type        = string
}

variable "master_username" {
  description = "Master username for cluster"
  type        = string
  default     = "admin"
}

variable "preferred_backup_window" {
  description = "Preferred backup window for the cluster"
  type        = string
  default     = "18:00-18:30"
}

variable "preferred_maintenance_window" {
  description = "Preferred maintenance window for the cluster"
  type        = string
  default     = "sat:19:00-sat:19:30"
}

# backup options
variable "maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "sun:04:32-sun:05:02"
}

variable "backup_window" {
  description = "Backup window"
  type        = string
  default     = "03:29-03:59"
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot for cluster on deletion"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "Set the VPC for security group"
  type = string
}

variable "allowed_port" {
  description = "The target port which is allowing for connecting to the RDS"
  type = number
  default = 5432 # postgres
}

variable "tags" {
  description = "A mapping of tags to assign to the cluster"
  type = map(string)
  default     = {}
}

variable "availability_zones" {
  description = "Availability zones"
  default = ["ap-northeast-1a"]
}

variable "source_security_group_id" {
  description = "The target security group which is allowing for accessing the RDS"
  type = string
}

variable "min_capacity" {
  type        = number
  description = "The minimum capacity for an Aurora DB cluster"
  default     = 2  # Valid values: 1, 2, 4, 8, 16, 32, 64, 128, 256
}
variable "max_capacity" {
  type        = number
  description = "The maximum capacity for an Aurora DB cluster"
  default     = 8  # Valid values: 1, 2, 4, 8, 16, 32, 64, 128, 256
}
variable "auto_pause" {
  type        = bool
  description = "true: cluster can be paused only when it's idle (it has no connections)"
  default     = true
}
variable "seconds_until_auto_pause" {
  type        = number
  description = "The time before cluster in serverless mode is paused"
  default     = 300  # Range: 300 - 86400 sec
}
variable "private_subnets" {
  description = "The subnet group to be used for the cluster"
  type = list(string)
  default = []
}
variable "enabled_cloudwatch_logs_exports" {
  default     = true
  type        = bool
  description = "Indicates that postgresql logs will be configured to be sent automatically to Cloudwatch"
}
variable "copy_tags_to_snapshot" {
  description = "Copy tags to snapshots"
  type        = bool
  default     = true
}
