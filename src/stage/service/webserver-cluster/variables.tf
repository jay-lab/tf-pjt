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
  default     = "t2.micro"
}
variable "asg_min_size" {
  type = number
  default = 1
}

variable "asg_max_size" {
  type = number
  default = 1
}