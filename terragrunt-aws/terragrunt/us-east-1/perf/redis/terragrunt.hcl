include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "region" {
  path = find_in_parent_folders("region.hcl")
}

terraform {
  source = "../../../../terraform-modules/aws-elasticache-redis"
}

locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env         = local.env_vars.locals.env
  region      = local.region_vars.locals.region

  redis_node_type_by_env = {
    dev        = "cache.t4g.micro"
    test       = "cache.t4g.small"
    perf       = "cache.t4g.medium"
    staging    = "cache.t4g.medium"
    production = "cache.r6g.large"
  }

  redis_num_cache_clusters_by_env = {
    dev        = 1
    test       = 1
    perf       = 2
    staging    = 2
    production = 2
  }

  redis_auth_token = get_env("REDIS_AUTH_TOKEN", "")
}

dependencies {
  paths = ["../network"]
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
  replication_group_id       = "demo-${local.env}-${local.region}-redis"
  description                = "Redis for ${local.env} in ${local.region}"
  node_type                  = local.redis_node_type_by_env[local.env]
  num_cache_clusters         = local.redis_num_cache_clusters_by_env[local.env]
  multi_az_enabled           = local.redis_num_cache_clusters_by_env[local.env] > 1
  automatic_failover_enabled = local.redis_num_cache_clusters_by_env[local.env] > 1
  subnet_ids                 = dependency.network.outputs.private_subnet_ids
  vpc_id                     = dependency.network.outputs.vpc_id
  allowed_cidr_blocks        = [local.env_vars.locals.vpc_cidr]
  auth_token                 = local.redis_auth_token != "" ? local.redis_auth_token : null

  tags = {
    Environment = local.env
    Workload    = "redis"
    Region      = local.region
  }
}
