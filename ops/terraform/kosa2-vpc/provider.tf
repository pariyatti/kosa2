terraform {
  required_version = ">= 1.5.7"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "pariyatti-tf-state-bucket"
    key    = "kosa2/kosa2-vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}