locals {
  env                 = "production"
  vpc_name_prefix     = "demo-vpc-us-west-2"
  cluster_name_prefix = "demo-production-eks"

  vpc_cidr        = "10.34.0.0/16"
  public_subnets  = ["10.34.0.0/24", "10.34.1.0/24", "10.34.2.0/24"]
  private_subnets = ["10.34.10.0/24", "10.34.11.0/24", "10.34.12.0/24"]

  eks_instance_types = ["m6i.xlarge"]
  eks_min_size       = 3
  eks_max_size       = 9
  eks_desired_size   = 3

  alb_allowed_cidrs = ["0.0.0.0/0"]
}
