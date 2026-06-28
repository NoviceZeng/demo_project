variable "name" {
  description = "VPC name."
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "Availability zones for the subnets."
  type        = list(string)
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT gateways for private subnets."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Whether to create a single shared NAT gateway."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
  default     = {}
}