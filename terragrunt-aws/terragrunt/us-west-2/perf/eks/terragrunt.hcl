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
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env         = local.env_vars.locals.env
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
  cluster_name            = "${local.env_vars.locals.cluster_name_prefix}-${local.region_vars.locals.region}"
  cluster_version         = "1.30"
  vpc_id                  = dependency.network.outputs.vpc_id
  subnet_ids              = dependency.network.outputs.private_subnet_ids
  endpoint_public_access  = true
  endpoint_private_access = true

  eks_managed_node_groups = {
    default = {
      instance_types = local.env_vars.locals.eks_instance_types
      min_size       = local.env_vars.locals.eks_min_size
      max_size       = local.env_vars.locals.eks_max_size
      desired_size   = local.env_vars.locals.eks_desired_size
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    Environment = local.env
    Workload    = "eks"
    Region      = local.region_vars.locals.region
  }
}
