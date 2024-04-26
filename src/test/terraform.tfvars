# region = "ap-northeast-2" # 서울
region = "us-east-1" # 버지니아 북부

security_group_ingress = {
  http = {
    description = "http"
    protocol    = "tcp"
    from_port   = "80"
    to_port     = "80"
    cidr_blocks = ["0.0.0.0/0"]
  },
  https = {
    description = "https"
    protocol    = "tcp"
    from_port   = "443"
    to_port     = "443"
    cidr_blocks = ["0.0.0.0/0"]
  },
  ssh = {
    description = "ssh"
    protocol    = "tcp"
    from_port   = "22"
    to_port     = "22"
    cidr_blocks = ["0.0.0.0/0"]
  }
}