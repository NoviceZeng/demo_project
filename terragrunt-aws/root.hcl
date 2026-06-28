# Root Terragrunt configuration for AWS infrastructure.

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  cloud {
    organization = "novicezeng"

    workspaces {
      name = "terragrunt-${replace(path_relative_to_include(), "/", "-")}"
    }
  }
}
EOF
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.56.0"
    }
  }
}

provider "aws" {
  region = var.region
}
EOF
}

inputs = {
  region = "us-east-1"

  default_tags = {
    ManagedBy = "terragrunt"
    Project   = "demo-project"
  }
}
