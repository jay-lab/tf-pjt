#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
# 단일 값에 대한 for 표현식
#▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
variable "user_names05" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["neo", "trinity", "morpheus"]
}

output "upper_names" {
  value = [for name in var.user_names05 : upper(name)]
}
# ✨✨✨✨✨ plan 결과 ✨✨✨✨✨
#upper_names = [
#  "NEO",
#  "TRINITY",
#  "MORPHEUS",
#]

output "short_upper_names" {
  value = [for name in var.user_names05 : upper(name) if length(name) < 5]
}
# ✨✨✨✨✨ plan 결과 ✨✨✨✨✨
#short_upper_names = [
# "NEO",
#]



#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
# map 값에 대한 for 표현식
#▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
variable "hero_thousand_faces" {
  description = "map"
  type        = map(string)
  default = {
    neo      = "hero"
    trinity  = "love interest"
    morpheus = "mentor"
  }
}
# map의 key, value를 가지고 가공된 list 값 구성하기 (대괄호가 사용되었듯 return 타입이 list.)
output "bios" {
  value = [for name, role in var.hero_thousand_faces : "${name} is the ${role}"]
}
# ✨✨✨✨✨ plan 결과 ✨✨✨✨✨
#bios = [
#  "morpheus is the mentor",
#  "neo is the hero",
#  "trinity is the love interest",
#]

# map의 key, value 가공하기 (중괄호가 사용되었듯 return 타입이 map.)
output "upper_roles" {
  value = { for name, role in var.hero_thousand_faces : upper(name) => upper(role) }
}
# ✨✨✨✨✨ plan 결과 ✨✨✨✨✨
#upper_roles = {
#  MORPHEUS = "MENTOR"
#  NEO      = "HERO"
#  TRINITY  = "LOVE INTEREST"
#}

# ☀️☀️☀️위 표현식을 응용하면 loop_test_03.tf 파일에 정리한 Dynamic Block에 대해서도 필터링&가공된 데이터로 loop를 적용할 수 있다.☀️☀️☀️
#dynamic "ingress" {
#  for_each = for_each = var.security_group_ingress ⬅️ before
#  for_each = { for key, value in var.security_group_ingress : key => upper(value) if key != "Name" } ⬅️ after
#  content {
#    description = ingress.value["description"]
#    protocol    = ingress.value["protocol"]
#    from_port   = ingress.value["from_port"]
#    to_port     = ingress.value["to_port"]
#    cidr_blocks = ingress.value["cidr_blocks"]
#  }
#}



#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
# for 문자열 지시자
#▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
output "for_directive" {
  value = <<-EOF
    %{for name in var.user_names05}
    ${name}
    %{endfor}
  EOF
}
# ✨✨✨✨✨ plan 결과 ✨✨✨✨✨
#for_directive = <<-EOT
#  neo
#
#  trinity
#
#  morpheus
#EOT

# 줄바꿈 없애는 방법
output "for_directive_2" {
  value = <<-EOF
    %{~for name in var.user_names05}
    ${name}
    %{~endfor}
  EOF
}
# ✨✨✨✨✨ plan 결과 ✨✨✨✨✨
#for_directive_2 = <<-EOT
#    neo
#    trinity
#    morpheus
#EOT


