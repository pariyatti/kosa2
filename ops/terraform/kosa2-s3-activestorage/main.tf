data "aws_availability_zones" "available" {}

locals {
  name   = basename(path.cwd)
  region = "us-east-1"

  tags = {
    Project    = local.name
    GithubRepo = "kosa2"
    GithubOrg  = "pariyatti"
  }
}

################################################################################
# S3 buckets for active storage
################################################################################

module "s3_bucket_activestorage_production" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "pariyatti-app-activestorage-production"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = false
  }
}

module "s3_bucket_activestorage_staging" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "pariyatti-app-activestorage-staging"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = false
  }
}