module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  cluster_endpoint_public_access  = var.endpoint_public_access
  cluster_endpoint_private_access = var.endpoint_private_access

  enable_cluster_creator_admin_permissions = true
  cluster_addons                           = var.cluster_addons
  eks_managed_node_groups                  = var.eks_managed_node_groups

  tags = var.tags
}