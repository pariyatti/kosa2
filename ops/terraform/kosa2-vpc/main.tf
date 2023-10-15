data "aws_availability_zones" "available" {}

locals {
  name   = "${basename(path.cwd)}"
  region = "us-east-1"

  vpc_cidr = "10.48.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Project    = local.name
    GithubRepo = "kosa2"
    GithubOrg  = "pariyatti"
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets     = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 6, k)]
  public_subnets      = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 6, k + 4)]
  database_subnets    = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 6, k + 8)]

  tags = local.tags
}