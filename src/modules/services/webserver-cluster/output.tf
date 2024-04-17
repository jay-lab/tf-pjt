#output "public_ip" {
#  value       = aws_instance.example.public_ip
#  description = "The public IP of the Instance"
#}


# 모듈화 전에는 해당 값을 출력했지만, 모듈화 이 후 기능하지않음.
# 이를 정상적으로 출력하기 위해서는
# child module에 구현되어있는 상태에서
# root module쪽에 output을 다시한번 구현해야한다.
output "alb_dns_name" {
  value       = aws_lb.example.dns_name
  description = "The domain name pf the load balancer"
}

# 이 값은 (ASG 서버 수 스케일링을 위해) root module에서 참조
output "asg_name" {
  value = aws_autoscaling_group.web_asg.name
  description = "The name of the Auto Scaling Group"
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
  description = "The ID of the Security Group attached to the load balancer"
}