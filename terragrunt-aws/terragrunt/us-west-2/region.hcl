locals {
  region = "us-west-2"
  azs    = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  region = local.region
  azs    = local.azs
}
