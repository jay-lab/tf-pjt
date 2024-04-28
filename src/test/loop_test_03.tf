/* [ Dynamic block ]
리소스를 반복적으로 여러개 생성(for_each의 기능)하는게 아니라
특정 리소스 안에있는  block 인자만을 반복 생성하는 것 */
variable "security_group_ingress" {
  type = map(object({
    description = string
    protocol    = string
    from_port   = string
    to_port     = string
    cidr_blocks = list(string)
  }))
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "main" {
  name        = "terraform-dynamicblock-test"
  description = "terraform-dynamicblock-test"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.security_group_ingress
    content {
      description = ingress.value["description"]
      protocol    = ingress.value["protocol"]
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-dynamicblock-test"
  }
}
# ✨✨✨✨✨ plan 결과 ✨✨✨✨✨
## aws_security_group.main will be created
#+ resource "aws_security_group" "main" {
#+ arn                    = (known after apply)
#+ description            = "terraform-dynamicblock-test"
#+ egress                 = [
#+ {
#+ cidr_blocks      = [
#+ "0.0.0.0/0",
#]
#+ description      = ""
#+ from_port        = 0
#+ ipv6_cidr_blocks = []
#+ prefix_list_ids  = []
#+ protocol         = "-1"
#+ security_groups  = []
#+ self             = false
#+ to_port          = 0
#},
#]
#+ id                     = (known after apply)
#+ ingress                = [
#+ {
#+ cidr_blocks      = [
#+ "0.0.0.0/0",
#]
#+ description      = "http"
#+ from_port        = 80
#+ ipv6_cidr_blocks = []
#+ prefix_list_ids  = []
#+ protocol         = "tcp"
#+ security_groups  = []
#+ self             = false
#+ to_port          = 80
#},
#+ {
#+ cidr_blocks      = [
#+ "0.0.0.0/0",
#]
#+ description      = "https"
#+ from_port        = 443
#+ ipv6_cidr_blocks = []
#+ prefix_list_ids  = []
#+ protocol         = "tcp"
#+ security_groups  = []
#+ self             = false
#+ to_port          = 443
#},
#+ {
#+ cidr_blocks      = [
#+ "0.0.0.0/0",
#]
#+ description      = "ssh"
#+ from_port        = 22
#+ ipv6_cidr_blocks = []
#+ prefix_list_ids  = []
#+ protocol         = "tcp"
#+ security_groups  = []
#+ self             = false
#+ to_port          = 22
#},
#]
#+ name                   = "terraform-dynamicblock-test"
#+ name_prefix            = (known after apply)
#+ owner_id               = (known after apply)
#+ revoke_rules_on_delete = false
#+ tags                   = {
#+ "Name" = "terraform-dynamicblock-test"
#}
#+ tags_all               = {
#+ "Name" = "terraform-dynamicblock-test"
#}
#+ vpc_id                 = "vpc-05819890763cddf88"
#}
