locals {
  region = "us-east-1"
  azs    = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  region = local.region
  azs    = local.azs
}
