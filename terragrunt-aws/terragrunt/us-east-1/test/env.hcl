locals {
  env                 = "test"
  vpc_name_prefix     = "demo-vpc-us-east-1"
  cluster_name_prefix = "demo-test-eks"

  vpc_cidr        = "10.11.0.0/16"
  public_subnets  = ["10.11.0.0/24", "10.11.1.0/24", "10.11.2.0/24"]
  private_subnets = ["10.11.10.0/24", "10.11.11.0/24", "10.11.12.0/24"]

  eks_instance_types = ["t3.large"]
  eks_min_size       = 1
  eks_max_size       = 3
  eks_desired_size   = 1

  alb_allowed_cidrs = ["0.0.0.0/0"]
}
