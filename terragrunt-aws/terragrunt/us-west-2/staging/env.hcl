locals {
  env                 = "staging"
  vpc_name_prefix     = "demo-vpc-us-west-2"
  cluster_name_prefix = "demo-staging-eks"

  vpc_cidr        = "10.33.0.0/16"
  public_subnets  = ["10.33.0.0/24", "10.33.1.0/24", "10.33.2.0/24"]
  private_subnets = ["10.33.10.0/24", "10.33.11.0/24", "10.33.12.0/24"]

  eks_instance_types = ["m6i.large"]
  eks_min_size       = 2
  eks_max_size       = 4
  eks_desired_size   = 2

  alb_allowed_cidrs = ["0.0.0.0/0"]
}
