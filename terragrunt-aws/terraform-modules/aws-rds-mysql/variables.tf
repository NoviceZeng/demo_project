variable "identifier" {
  description = "RDS instance identifier."
  type        = string
}

variable "db_name" {
  description = "Initial database name."
  type        = string
  default     = null
}

variable "username" {
  description = "Master username for the database."
  type        = string
}

variable "password" {
  description = "Master password for the database."
  type        = string
  sensitive   = true
}

variable "engine_version" {
  description = "MySQL engine version."
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage in GiB."
  type        = number
}

variable "max_allocated_storage" {
  description = "Maximum autoscaling storage in GiB."
  type        = number
  default     = 0
}

variable "storage_type" {
  description = "Storage type for the DB instance."
  type        = string
  default     = "gp3"
}

variable "storage_encrypted" {
  description = "Whether storage encryption is enabled."
  type        = bool
  default     = true
}

variable "multi_az" {
  description = "Whether to deploy Multi-AZ RDS instance."
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "Private subnet IDs for DB subnet group."
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the DB security group will be created."
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "Allowed CIDR blocks for MySQL access."
  type        = list(string)
}

variable "port" {
  description = "MySQL port."
  type        = number
  default     = 3306
}

variable "backup_retention_period" {
  description = "Backup retention period in days."
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled."
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot on destroy."
  type        = bool
  default     = false
}

variable "final_snapshot_identifier" {
  description = "Final snapshot identifier when destroying."
  type        = string
  default     = null
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
  default     = {}
}
