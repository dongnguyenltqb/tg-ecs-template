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

variable "db_subnet_group_name" {
  description = "A DB subnet group to be used for the cluster"
  type        = string
}

variable "deletion_protection" {
  description = "Prevent deletion of the db cluster"
  type        = bool
  default     = false
}

variable "engine" {
  description = "DB engine type"
  type        = string
  default     = "aurora"
}

variable "engine_version" {
  description = "DB engine version"
  type        = string
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
  default     = "03:00-06:00"
}

variable "preferred_maintenance_window" {
  description = "Preferred maintenance window for the cluster"
  type        = string
  default     = "wed:04:00-wed04:30"
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot for cluster on deletion"
  type        = bool
  default     = false
}

variable "number_of_instances" {
  description = "Specify the number of instances for the cluster"
  type = number
  default = 1
}

variable "instance_size" {
  description = "Specify the instance type"
  type = string
  default = "db.t3.medium"
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
