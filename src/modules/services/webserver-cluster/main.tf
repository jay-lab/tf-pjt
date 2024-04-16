# 모듈화 후 root module 파일에 적용해야 정상적으로 적용
#terraform {
#  required_version = ">= 1.0.0, < 2.0.0"
#
#  required_providers {
#    aws = {
#      source  = "hashicorp/aws"
#      version = "~> 5.0"
#    }
#  }
#
#  backend "s3" {
#    bucket = "terraform-state-sj"
#    key = "global/s3/terraform.tfstate" # 저장될 파일의 'S3 버킷 경로/상태파일명'
#    region = "us-east-1"
#
#    dynamodb_table = "terraform-locks" # 생성한 DynamoDB Table의 이름
#    encrypt = true
#  }
#}

# 모듈화 하면서 provider 제거(루트모듈에서 정의하는 것이 정석)
#provider "aws" {
#  region = var.region
#}