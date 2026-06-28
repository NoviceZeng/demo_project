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
  env         = "dev"
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

inputs = {
  name            = "${local.region_vars.locals.vpc_name}-${local.env}"
  cidr_block      = local.region_vars.locals.dev_vpc_cidr
  azs             = local.region_vars.locals.azs
  public_subnets  = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
  private_subnets = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"]

  tags = {
    Environment = local.env
    Platform    = "demo"
  }
}
