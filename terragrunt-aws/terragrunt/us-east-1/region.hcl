locals {
  region = "us-east-1"
  azs    = ["us-east-1a", "us-east-1b", "us-east-1c"]

  vpc_name      = "demo-vpc-us-east-1"
  dev_vpc_cidr  = "10.10.0.0/16"
  prod_vpc_cidr = "10.20.0.0/16"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  region = local.region
  azs    = local.azs
}
