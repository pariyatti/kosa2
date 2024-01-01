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
# S3 bucket: pariyatti-kosa2-postgresql-db-backup
################################################################################

module "s3_bucket_postgresql_backup" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "pariyatti-kosa2-postgresql-db-backup"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}