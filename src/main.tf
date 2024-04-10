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
#  region = "ap-northeast-2" # Asia Pacific (Seoul) region
  region = "us-east-1" # 버지니아 북부
}

resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file("./mykey.pub")
}

resource "aws_instance" "example" {
  ami                    = "ami-051f8a213df8bc089"
  instance_type          = "t2.micro"
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

resource "aws_security_group" "instance" {

  name = var.security_group_name

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "terraform-example-instance"
}

variable "server_port" {
  description = "The port the server will user for HTTP requests"
  type = number
  default = 8080
}

output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the Instance"
}