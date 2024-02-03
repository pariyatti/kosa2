locals {
  tags = {
    Project    = "kosa2-prod"
    GithubRepo = "kosa2"
    GithubOrg  = "pariyatti"
  }
}

resource "aws_efs_file_system" "kosa2_efs_prod" {
  creation_token   = "kosa2-efs-prod"
  performance_mode = "generalPurpose"

  encrypted = true

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags

}

data "aws_subnets" "kosa2_public" {
  filter {
    name   = "tag:Name"
    values = ["kosa2-vpc-public-us-east-1a", "kosa2-vpc-public-us-east-1b", "kosa2-vpc-public-us-east-1c"]
  }
}

data "aws_security_group" "kosa_efs_sg" {
  tags = {
    Name = "kosa2-efs-sg"
  }
}

resource "aws_efs_mount_target" "kosa2_efs_prod" {
  for_each        = toset(data.aws_subnets.kosa2_public.ids)
  file_system_id  = aws_efs_file_system.kosa2_efs_prod.id
  subnet_id       = each.value
  security_groups = [data.aws_security_group.kosa_efs_sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

