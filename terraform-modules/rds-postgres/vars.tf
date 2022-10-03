variable "region" {
  type = string
}
variable "environment" {
  type = string
}
variable "multi_az" {
  type    = bool
  default = false
}

variable "vpc_id" {
  description = "Set the VPC for security group"
  type        = string
}

variable "identifier_prefix" {
  description = "Identifier prefix for the RDS instance"
  type        = string
  default     = "sp-"
}
variable "master_dbname" {
  description = "Specify the database name"
  type        = string
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
variable "cluster_identifier" {
  description = "The name of the postgres database to create on the DB instance"
  type        = string
}
variable "allocated_storage" {
  description = "Allocate storage"
  type        = number
  default     = 10
}
variable "max_allocated_storage" {
  description = "Max allocate storage"
  type        = number
  default     = 30
}
variable "storage_type" {
  description = "Storage type (e.g. gp2, io1)"
  type        = string
  default     = "gp2"
}
variable "instance_class" {
  description = "Instance class"
  default     = "db.t3.medium"
}
variable "allowed_port" {
  description = "The target port which is allowing for connecting to the RDS"
  type        = number
  default     = 5432 # postgres
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
variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 14
}
variable "skip_final_snapshot" {
  description = "Skip final snapshot"
  type        = bool
  default     = true
}
variable "private_subnets" {
  description = "VPC subnet IDs in subnet group"
  type        = list(string)
}
variable "source_security_group_ids" {
  description = "The target security group which is allowing for accessing the RDS"
  type        = list(string)
}
variable "engine_version" {
  type    = string
  default = "13.3"
}
variable "availability_zone" {
  type    = string
  default = "ap-southeast-1a"
}
variable "copy_tags_to_snapshot" {
  description = "Copy tags to snapshots"
  type        = bool
  default     = true
}
# parameters group
variable "parameter_group_name" {
  description = "The name of the rds parameter group"
  type        = string
  default     = null
}
variable "param_log_min_duration_statement" {
  description = "(ms) Sets the minimum execution time above which statements will be logged."
  type        = string
  default     = "-1"
}
variable "param_log_statement" {
  description = "Sets the type of statements logged. Valid values are none, ddl, mod, all"
  type        = string
  default     = "none"
}
variable "parameter_group_family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = "postgres12"
}
variable "tags" {
  description = "A mapping of tags to assign to the cluster"
  type        = map(string)
  default     = {}
}
variable "apply_immediately" {
  description = "Apply immediately, do not set this to true for production"
  type        = bool
  default     = false
}
variable "enabled_cloudwatch_logs_exports" {
  default     = true
  type        = bool
  description = "Indicates that postgresql logs will be configured to be sent automatically to Cloudwatch"
}
