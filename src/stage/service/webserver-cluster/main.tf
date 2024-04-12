terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-sj"
    key = "global/s3/terraform.tfstate" # 저장될 파일의 'S3 버킷 경로/상태파일명'
    region = "us-east-1"

    dynamodb_table = "terraform-locks" # 생성한 DynamoDB Table의 이름
    encrypt = true
  }
}

provider "aws" {
  region = var.region
}