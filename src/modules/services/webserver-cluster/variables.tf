variable "region" {
  type    = string
  default = ""
}

variable "key_pair_name" {
  type    = string
  default = ""
}

variable "key_pair_path" {
  type    = string
  default = ""
}

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = ""
}

variable "server_port" {
  description = "The port the server will user for HTTP requests"
  type        = number
  default     = 80
}

variable "image_id" {
  description = "The id of the machine image (AMI) to use for the server."
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "instance type"
  type        = string
}
variable "asg_min_size" {
  type = number
}

variable "asg_max_size" {
  type = number
}

## 모듈화 이후 추가 변수
variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type = string
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state in S3"
  type = string
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
  type = string
}

locals {
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}