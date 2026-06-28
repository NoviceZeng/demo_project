locals {
  env                 = "staging"
  vpc_name_prefix     = "demo-vpc-us-east-1"
  cluster_name_prefix = "demo-staging-eks"

  vpc_cidr        = "10.13.0.0/16"
  public_subnets  = ["10.13.0.0/24", "10.13.1.0/24", "10.13.2.0/24"]
  private_subnets = ["10.13.10.0/24", "10.13.11.0/24", "10.13.12.0/24"]

  eks_instance_types = ["m6i.large"]
  eks_min_size       = 2
  eks_max_size       = 4
  eks_desired_size   = 2

  alb_allowed_cidrs = ["0.0.0.0/0"]
}
