locals {
  region = "us-west-2"
  azs    = ["us-west-2a", "us-west-2b", "us-west-2c"]

  vpc_name      = "demo-vpc-us-west-2"
  dev_vpc_cidr  = "10.30.0.0/16"
  prod_vpc_cidr = "10.40.0.0/16"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  region = local.region
  azs    = local.azs
}
