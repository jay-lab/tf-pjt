resource "aws_key_pair" "mykey" {
  key_name   = var.key_pair_name
  public_key = file(var.key_pair_path)
}


resource "aws_instance" "example" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data_replace_on_change = true
  key_name                    = aws_key_pair.mykey.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum -y install httpd
              sed -i 's/Listen 80/Listen ${var.server_port}/' /etc/httpd/conf/httpd.conf
              systemctl enable httpd
              systemctl restart httpd
              echo '<html><h1>Hello World!</h1></html>' > /var/www/html/index.html
              EOF

  tags = {
    Name = "terraform-example"
  }
}

resource "aws_launch_configuration" "example" {
  image_id      = var.image_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              yum -y install httpd
              sed -i 's/Listen 80/Listen ${var.server_port}/' /etc/httpd/conf/httpd.conf
              systemctl enable httpd
              systemctl restart httpd
              echo '<html><h1>Hello World!</h1></html>' > /var/www/html/index.html
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.id
  vpc_zone_identifier = data.aws_subnet_ids.default.ids

  min_size = 2
  max_size = 10

  tag {
    key = "Name"
    value = "terraform-asg-example"

    propagate_at_launch = true # ASG에 의해 생성되는 모든 인스턴스가 이 태그를 상속.
    /* 스케일 아웃(인스턴스 추가) 또는 스케일 인(인스턴스 제거) 작업을 수행할 때, 이 속성이 true로 설정되어 있으면,
    해당 태그가 새로운 인스턴스에 자동으로 적용되어 관리와 모니터링을 일관성 있게 유지할 수 있습니다.*/
  }
}