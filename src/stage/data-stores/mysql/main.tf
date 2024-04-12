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
    key = "stage/data-stores/mysql/terraform.tfstate" # 저장될 파일의 'S3 버킷 경로/상태파일명'
    region = "us-east-1"

    dynamodb_table = "terraform-locks" # 생성한 DynamoDB Table의 이름
    encrypt = true
  }
}

provider "aws" {
  region = var.region
}

resource "aws_db_instance" "example" {
  identifier_prefix = "terraform-db"
  engine = "mysql"
  allocated_storage = 10 # 스토리지 10 GB
  instance_class = "db.t2.micro" # 1 CPU, 1 GB Memory
  db_name = "example_database"
  username = "admin"
  password = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["key1"] # 보안암호 명 "mysql-master-password-stage"의 "key1" 이라는 key의 값
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "mysql-master-password-stage" # AWS SecretManager에 생성 되어있어야할 키값(복수의 key-value json 객체 형태. 따라서 위와같이 decode & key를 활용해서 value에 접근 필요)
}

