include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "region" {
  path = find_in_parent_folders("region.hcl")
}

terraform {
  source = "../../../../terraform-modules/aws-rds-mysql"
}

locals {
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env         = local.env_vars.locals.env
  region      = local.region_vars.locals.region

  db_instance_class_by_env = {
    dev        = "db.t4g.micro"
    test       = "db.t4g.small"
    perf       = "db.t4g.medium"
    staging    = "db.t4g.medium"
    production = "db.t4g.large"
  }

  db_allocated_storage_by_env = {
    dev        = 20
    test       = 30
    perf       = 80
    staging    = 80
    production = 150
  }

  db_multi_az_by_env = {
    dev        = false
    test       = false
    perf       = true
    staging    = true
    production = true
  }

  db_deletion_protection_by_env = {
    dev        = false
    test       = false
    perf       = true
    staging    = true
    production = true
  }

  db_password = get_env("MYSQL_MASTER_PASSWORD", "ChangeMe123!")
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
  identifier                = "demo-${local.env}-${local.region}-mysql"
  db_name                   = "appdb"
  username                  = "admin"
  password                  = local.db_password
  instance_class            = local.db_instance_class_by_env[local.env]
  allocated_storage         = local.db_allocated_storage_by_env[local.env]
  max_allocated_storage     = local.db_allocated_storage_by_env[local.env] * 2
  multi_az                  = local.db_multi_az_by_env[local.env]
  subnet_ids                = dependency.network.outputs.private_subnet_ids
  vpc_id                    = dependency.network.outputs.vpc_id
  allowed_cidr_blocks       = [local.env_vars.locals.vpc_cidr]
  backup_retention_period   = local.env == "production" ? 14 : 7
  deletion_protection       = local.db_deletion_protection_by_env[local.env]
  skip_final_snapshot       = local.env == "production" ? false : true
  final_snapshot_identifier = local.env == "production" ? "demo-${local.env}-${local.region}-mysql-final" : null

  tags = {
    Environment = local.env
    Workload    = "mysql-rds"
    Region      = local.region
  }
}
