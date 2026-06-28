locals {
  env                 = "perf"
  vpc_name_prefix     = "demo-vpc-us-west-2"
  cluster_name_prefix = "demo-perf-eks"

  vpc_cidr        = "10.32.0.0/16"
  public_subnets  = ["10.32.0.0/24", "10.32.1.0/24", "10.32.2.0/24"]
  private_subnets = ["10.32.10.0/24", "10.32.11.0/24", "10.32.12.0/24"]

  eks_instance_types = ["m6i.large"]
  eks_min_size       = 2
  eks_max_size       = 6
  eks_desired_size   = 2

  alb_allowed_cidrs = ["0.0.0.0/0"]
}
