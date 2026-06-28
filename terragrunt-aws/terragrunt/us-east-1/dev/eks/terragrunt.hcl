include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "region" {
  path = find_in_parent_folders("region.hcl")
}

terraform {
  source = "../../../../terraform-modules/aws-eks"
}

locals {
  env = "dev"
}

dependency "network" {
  config_path = "../network"

  mock_outputs = {
    vpc_id             = "vpc-12345678"
    private_subnet_ids = ["subnet-private-a", "subnet-private-b", "subnet-private-c"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  cluster_name            = "demo-${local.env}-eks"
  cluster_version         = "1.30"
  vpc_id                  = dependency.network.outputs.vpc_id
  subnet_ids              = dependency.network.outputs.private_subnet_ids
  endpoint_public_access  = true
  endpoint_private_access = true

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 3
      desired_size   = 1
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    Environment = local.env
    Workload    = "eks"
  }
}
