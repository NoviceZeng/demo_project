locals {
  region = "us-east-1"
  azs    = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

inputs = {
  region = local.region
  azs    = local.azs
}
