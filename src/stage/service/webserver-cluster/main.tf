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
    key    = "global/s3/terraform.tfstate" # 저장될 파일의 'S3 버킷 경로/상태파일명'
    region = "us-east-1"

    dynamodb_table = "terraform-locks" # 생성한 DynamoDB Table의 이름
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "terraform-state-sj"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"

  region = "us-east-1"

  key_pair_name = "mykey"
  key_pair_path = "keypair/mykey.pub"

  security_group_name = "terraform-example-instance"
  server_port         = 8080
  image_id            = "ami-051f8a213df8bc089"
  instance_type       = "t2.micro"

  asg_min_size = 2
  asg_max_size = 2
}

# 아래 리소스는 Prod 환경에만 설정될 코드. 업무시간에만 Prod 서버 수 늘리는 용도.
/* 참고로 "autoscaling_group_name"는 필수매개변수. 그런데,
 `autoscaling_group_name = aws_autoscaling_group.web_asg.name`
 ▲ 위 코드 사용 불가. root에서 child 리소스 참조 불가능하기 때문.
 이러한 문제를 해결하기 위해 child에 구현된 output을 이용하여 모듈이 반환하는 값을 사용할 수 있다 */
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name  = "scale-out-during-business-hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 10
  recurrence             = "0 9 * * *"
  autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name  = "scale-in-at-night"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 10
  recurrence             = "0 17 * * *"
  autoscaling_group_name = module.webserver_cluster.asg_name
}

# 모듈에 선언되어있는 aws_security_group_rule 말고도
# root module에서도 사용자 정의 규칙을 '유연하게 추가'할 수 있다는 것을 보여주는 내용의 코드
resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}