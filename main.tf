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

module "s3_lambda_listener" {
  source = "./modules/s3_lambda_listener"
}

module "presigned_url_lambda" {
  source = "./modules/presigned_url_lambda"
}