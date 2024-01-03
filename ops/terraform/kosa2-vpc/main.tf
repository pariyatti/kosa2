data "aws_availability_zones" "available" {}

locals {
  name   = basename(path.cwd)
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

  azs              = local.azs
  private_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 6, k)]
  public_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 6, k + 4)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 6, k + 8)]

  tags = local.tags
}

module "kosa_asg_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "kosa2-asg-sg"
  description = "Kosa2 security group"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]

  egress_rules = ["all-all"]

  tags = local.tags
}

module "kosa_efs_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/nfs"
  version = "~> 5.0"

  name        = "kosa2-efs-sg"
  description = "Kosa2 EFS security group"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [local.vpc_cidr]

  ingress_with_source_security_group_id = [{
    rule                     = "nfs-tcp",
    source_security_group_id = module.kosa_asg_sg.security_group_id
  }]


  tags = local.tags
}