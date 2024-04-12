terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
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
  secret_id = "mysql-master-password-stage" # AWS SecretManager에 생성 되어있어야할 키값
}