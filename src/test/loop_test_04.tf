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
