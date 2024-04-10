# region = "ap-northeast-2" # 서울
region = "us-east-1" # 버지니아 북부

key_pair_name = "mykey"
key_pair_path = "./keypair/mykey.pub"

security_group_name = "terraform-example-instance"
server_port         = 8080
image_id            = "ami-051f8a213df8bc089"
instance_type       = "t2.micro"

asg_min_size = 2
asg_max_size = 10