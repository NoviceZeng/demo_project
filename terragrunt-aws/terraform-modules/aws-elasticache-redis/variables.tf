variable "replication_group_id" {
  description = "ElastiCache replication group identifier."
  type        = string
}

variable "description" {
  description = "Description for ElastiCache replication group."
  type        = string
}

variable "engine_version" {
  description = "Redis engine version."
  type        = string
  default     = "7.1"
}

variable "node_type" {
  description = "ElastiCache node type."
  type        = string
}

variable "num_cache_clusters" {
  description = "Number of cache clusters in the replication group."
  type        = number
  default     = 1
}

variable "multi_az_enabled" {
  description = "Whether Multi-AZ is enabled for Redis replication group."
  type        = bool
  default     = false
}

variable "automatic_failover_enabled" {
  description = "Whether automatic failover is enabled."
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "Private subnet IDs for ElastiCache subnet group."
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where security group will be created."
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "Allowed CIDR blocks for Redis port access."
  type        = list(string)
}

variable "port" {
  description = "Redis port."
  type        = number
  default     = 6379
}

variable "at_rest_encryption_enabled" {
  description = "Enable encryption at rest."
  type        = bool
  default     = true
}

variable "transit_encryption_enabled" {
  description = "Enable encryption in transit."
  type        = bool
  default     = true
}

variable "auth_token" {
  description = "Redis AUTH token. Required when transit encryption is enabled for auth."
  type        = string
  default     = null
  sensitive   = true
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
  default     = {}
}
