resource "aws_key_pair" "mykey" {
  key_name   = var.key_pair_name
  public_key = file("${path.module}/${var.key_pair_path}")
}


#resource "aws_instance" "example" {
#  ami                    = var.image_id
#  instance_type          = var.instance_type
#  vpc_security_group_ids = [aws_security_group.instance.id]
#  user_data_replace_on_change = true
#  key_name                    = aws_key_pair.mykey.key_name
#
#  user_data = <<-EOF
#              #!/bin/bash
#              yum -y install httpd
#              sed -i 's/Listen 80/Listen ${var.server_port}/' /etc/httpd/conf/httpd.conf
#              systemctl enable httpd
#              systemctl restart httpd
#              echo '<html><h1>Hello World!</h1></html>' > /var/www/html/index.html
#              EOF
#
#  tags = {
#    Name = "terraform-example"
#  }
#}

resource "aws_launch_template" "web" {
  name_prefix            = "lt-web-"
  image_id               = var.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = aws_key_pair.mykey.key_name

  user_data = base64encode(templatefile("${path.module}/user-data.tftpl", {
    server_port = var.server_port
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
  }))
}

resource "aws_autoscaling_group" "web_asg" {
  name_prefix = "asg-web-"
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
  vpc_zone_identifier = data.aws_subnets.default.ids

  min_size = var.asg_min_size
  max_size = var.asg_max_size

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  tag {
    key   = "Name"
    value = var.cluster_name

    propagate_at_launch = true # ASG에 의해 생성되는 모든 인스턴스가 이 태그를 상속.
    /* 스케일 아웃(인스턴스 추가) 또는 스케일 인(인스턴스 제거) 작업을 수행할 때, 이 속성이 true로 설정되어 있으면,
    해당 태그가 새로운 인스턴스에 자동으로 적용되어 관리와 모니터링을 일관성 있게 유지할 수 있습니다.*/
  }

  lifecycle {
    create_before_destroy = true
    replace_triggered_by = [
      aws_launch_template.web.latest_version
    ]
  }
}

resource "aws_lb" "example" {
  name               = "terraform-asg-example"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = local.http_port
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found!~"
      status_code  = 404
    }
  }
}
resource "aws_lb_target_group" "asg" {
  name     = "terraform-asg-example"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200" # 건강 상태 검사 응답으로 받아들일 HTTP 상태 코드를 지정
    interval            = 15    # 로드 밸런서가 15초마다 타겟의 건강 상태를 점검한다는 것을 의미
    timeout             = 3     # 건강 상태 점검 요청에 대한 응답을 기다리는 최대 시간(초 단위)
    healthy_threshold   = 2     # 타겟이 건강하다고 판단하기 위해 연속으로 성공해야 하는 건강 상태 점검의 최소 횟수입니다. 이 예제에서는 2로 설정되어 있으며, 이는 연속적으로 두 번의 건강 상태 점검이 성공해야 타겟이 건강한 것으로 판단
    unhealthy_threshold = 2     # 타겟이 건강하지 않다고 판단하기 위해 연속으로 실패해야 하는 건강 상태 점검의 최소 횟수입니다. 이 예제에서도 2로 설정되어 있어, 연속적으로 두 번의 건강 상태 점검이 실패하면 타겟이 건강하지 않은 것으로 간주
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}