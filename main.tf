terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49"
    }
  }

  required_version = ">= 1.8.3"
}

module "aws_s3_bucket" {
  source = "./modules/aws_s3_bucket"

}