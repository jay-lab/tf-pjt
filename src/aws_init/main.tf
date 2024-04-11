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

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-sj"
  force_destroy = true
#  lifecycle {
#    prevent_destroy = true
#  }
}

# 코드 이력 관리하기 위해 상태 파일의 버전 관리 활성화
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "my_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

# 서버 측 암호화 활성화
resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_object" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.my_kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

#############################################################################
# DynamoDB
#############################################################################
resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}