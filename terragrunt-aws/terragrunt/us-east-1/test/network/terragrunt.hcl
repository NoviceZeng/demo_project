include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "region" {
  path = find_in_parent_folders("region.hcl")
}

terraform {
  source = "../../../../terraform-modules/aws-network"
}

locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env         = local.env_vars.locals.env
}

inputs = {
  name            = "${local.env_vars.locals.vpc_name_prefix}-${local.env}"
  cidr_block      = local.env_vars.locals.vpc_cidr
  azs             = local.region_vars.locals.azs
  public_subnets  = local.env_vars.locals.public_subnets
  private_subnets = local.env_vars.locals.private_subnets

  tags = {
    Environment = local.env
    Platform    = "demo"
    Region      = local.region_vars.locals.region
  }
}
