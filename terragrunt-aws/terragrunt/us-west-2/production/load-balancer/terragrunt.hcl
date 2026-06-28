include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "region" {
  path = find_in_parent_folders("region.hcl")
}

terraform {
  source = "../../../../terraform-modules/aws-alb"
}

locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env         = local.env_vars.locals.env
}

dependencies {
  paths = ["../network", "../eks"]
}

dependency "network" {
  config_path = "../network"

  mock_outputs = {
    vpc_id            = "vpc-12345678"
    public_subnet_ids = ["subnet-public-a", "subnet-public-b", "subnet-public-c"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  name              = "demo-${local.env}-${local.region_vars.locals.region}-alb"
  vpc_id            = dependency.network.outputs.vpc_id
  subnet_ids        = dependency.network.outputs.public_subnet_ids
  allowed_cidrs     = local.env_vars.locals.alb_allowed_cidrs
  listener_port     = 80
  target_port       = 80
  target_type       = "ip"
  health_check_path = "/"

  tags = {
    Environment = local.env
    Workload    = "ingress"
    Region      = local.region_vars.locals.region
  }
}
