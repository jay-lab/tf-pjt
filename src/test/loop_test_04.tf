# 단일 값에 대한 for 표현식
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

#######################################################################
# map 값에 대한 for 표현식
variable "hero_thousand_faces" {
  description = "map"
  type        = map(string)
  default = {
    neo      = "hero"
    trinity  = "love interest"
    morpheus = "mentor"
  }
}
# map의 key, value를 가지고 가공된 list 값 구성하기
output "bios" {
  value = [for name, role in var.hero_thousand_faces : "${name} is the ${role}"]
}
# ✨✨✨✨✨ plan 결과 ✨✨✨✨✨
#bios = [
#  "morpheus is the mentor",
#  "neo is the hero",
#  "trinity is the love interest",
#]

# map의 key, value 가공하기
output "upper_roles" {
  value = {for name, role in var.hero_thousand_faces : upper(name) => upper(role)}
}
# ✨✨✨✨✨ plan 결과 ✨✨✨✨✨
#upper_roles = {
#  MORPHEUS = "MENTOR"
#  NEO      = "HERO"
#  TRINITY  = "LOVE INTEREST"
#}
