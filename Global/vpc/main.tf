data "aws_availability_zones" "available" {}

locals {
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}
################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "../../modules/vpc"

  name = var.name
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = [
    "10.0.4.0/24", # Subnet for ap-south-1a
    # "10.0.5.0/24", # Subnet for ap-south-1b
    # "10.0.6.0/24"  # Subnet for ap-south-1c
  ]
 public_subnets = [
     "10.0.1.0/24",  # Subnet for ap-south-1a
  ]
  tags = var.tags
}
