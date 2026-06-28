locals {
  env                 = "dev"
  vpc_name_prefix     = "demo-vpc-us-east-1"
  cluster_name_prefix = "demo-dev-eks"

  vpc_cidr        = "10.10.0.0/16"
  public_subnets  = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
  private_subnets = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"]

  eks_instance_types = ["t3.medium"]
  eks_min_size       = 1
  eks_max_size       = 3
  eks_desired_size   = 1

  alb_allowed_cidrs = ["0.0.0.0/0"]
}
