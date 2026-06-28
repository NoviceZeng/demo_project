variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the cluster."
  type        = string
  default     = "1.30"
}

variable "vpc_id" {
  description = "VPC ID where the cluster is created."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs used by the cluster."
  type        = list(string)
}

variable "endpoint_public_access" {
  description = "Whether the EKS API server is exposed publicly."
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Whether the EKS API server is exposed privately."
  type        = bool
  default     = true
}

variable "cluster_addons" {
  description = "EKS cluster addons."
  type        = map(any)
  default = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
  }
}

variable "eks_managed_node_groups" {
  description = "Managed node group definitions."
  type        = map(any)
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
  default     = {}
}