# local variable store common tag
generate "locals" {
  path      = "locals.tf"
  if_exists = "skip"
  contents  = <<EOF
  locals {
    tags = {
      Environment = "dev"
    }
  }
EOF
}


# default provider and region setting
generate "provider" {
  path      = "provider.tf"
  if_exists = "skip"
  contents  = <<EOF
  terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "4.29.0"
      }
    }
  }

  provider "aws" {
    region = "ap-southeast-1"
  }
EOF
}