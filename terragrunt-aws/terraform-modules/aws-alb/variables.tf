variable "name" {
  description = "Application load balancer name."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where the ALB is deployed."
  type        = list(string)
}

variable "internal" {
  description = "Whether the ALB is internal."
  type        = bool
  default     = false
}

variable "allowed_cidrs" {
  description = "CIDR blocks allowed to reach the ALB listener."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "listener_port" {
  description = "Listener port for the ALB."
  type        = number
  default     = 80
}

variable "target_port" {
  description = "Target group backend port."
  type        = number
  default     = 80
}

variable "target_type" {
  description = "Target type for the target group."
  type        = string
  default     = "ip"
}

variable "health_check_path" {
  description = "Health check path for HTTP backends."
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
  default     = {}
}