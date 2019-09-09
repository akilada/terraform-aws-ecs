terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
  required_version = "= 0.11.14"
}
provider "aws" {
  region  = "${var.aws_region}"
}