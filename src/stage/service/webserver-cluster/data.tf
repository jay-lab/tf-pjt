data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
# 이 data 리소스를 통해 백엔드 버킷의 상태파일을 읽는 방식 -> 상태파일에 저장되어있는 DB의 출력변수 조회
# 다음 속성참조를 이용해서 terraform_remote_state 데이터 소스에서 읽을 수 있다
# data.terraform_remote_state.<NAME>.outputs.<ATTRIBUTE>
data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "terraform-state-sj"
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"
  }
}

/* ################## User Data 사용방식 2 - "user-data.sh" + "data" ##################
(user_data = data.tamplate_file.user_data.rendered 로 사용 가능) */
#data "template_file" "user_data" {
#  template = file("user-data.sh")
#  vars = {
#    server_port = var.server_port
#    db_address = data.terraform_remote_state.db.outputs.adress
#    db_port = data.terraform_remote_state.db.outputs.port
#  }
#}