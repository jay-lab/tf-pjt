resource "aws_security_group" "instance" {
  name = var.security_group_name

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = local.any_port
    cidr_blocks = local.all_ips
  }
}

resource "aws_security_group" "alb" {
  name = "${var.cluster_name}-alb"
#  ▼  모듈화하면서 아래 인라인 방식를 별도 리소스 aws_security_group_rule을 사용하는 방식으로 변경
#  # 인바운드 HTTP 트래픽 허용
#  ingress {
#    from_port   = local.http_port
#    to_port     = local.http_port
#    protocol    = local.tcp_protocol
#    cidr_blocks = local.all_ips
#  }
#
#  # 모든 아웃바운드 트래픽 허용
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
}

# 이렇게 aws_security_group_rule을 사용하여 inbound 규칙을 추가했지만, module 외부에서(ex:root module)
# 사용자 정의 규칙을 추가할 수 있도록 모듈을 유연하게 만들 수 있다. 이를 위해 output에서 출력변수로 내보내기 필요
resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id

  from_port   = local.http_port
  to_port     = local.http_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_http_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id

  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
}