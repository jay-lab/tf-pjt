variable "user_names04" {
  description = "Create IAM users with these names"
  type = list(string)
  default = ["neo", "trinity", "morpheus"]
}

resource "aws_iam_user" "example04" {
  for_each = toset(var.user_names04) # for_each는 리소스에서 사용될 때만 집합과 맵을 지원
  name = each.value
}
# ✨✨✨✨✨ plan 결과 ✨✨✨✨✨
## aws_iam_user.example01["morpheus"] will be created
#+ resource "aws_iam_user" "example04" {
#+ arn           = (known after apply)
#+ force_destroy = false
#+ id            = (known after apply)
#+ name          = "morpheus"
#+ path          = "/"
#+ tags_all      = (known after apply)
#+ unique_id     = (known after apply)
#}
#
## aws_iam_user.example01["neo"] will be created
#+ resource "aws_iam_user" "example04" {
#+ arn           = (known after apply)
#+ force_destroy = false
#+ id            = (known after apply)
#+ name          = "neo"
#+ path          = "/"
#+ tags_all      = (known after apply)
#+ unique_id     = (known after apply)
#}
#
## aws_iam_user.example01["trinity"] will be created
#+ resource "aws_iam_user" "example04" {
#+ arn           = (known after apply)
#+ force_destroy = false
#+ id            = (known after apply)
#+ name          = "trinity"
#+ path          = "/"
#+ tags_all      = (known after apply)
#+ unique_id     = (known after apply)
#}

output "all_users04" {
  value = aws_iam_user.example04
}
# ✨✨✨✨✨ plan 결과 ✨✨✨✨✨
#+ all_users04 = {
#+ morpheus = {
#+ arn                  = (known after apply)
#+ force_destroy        = false
#+ id                   = (known after apply)
#+ name                 = "morpheus"
#+ path                 = "/"
#+ permissions_boundary = null
#+ tags                 = null
#+ tags_all             = (known after apply)
#+ unique_id            = (known after apply)
#}
#+ neo      = {
#+ arn                  = (known after apply)
#+ force_destroy        = false
#+ id                   = (known after apply)
#+ name                 = "neo"
#+ path                 = "/"
#+ permissions_boundary = null
#+ tags                 = null
#+ tags_all             = (known after apply)
#+ unique_id            = (known after apply)
#}
#+ trinity  = {
#+ arn                  = (known after apply)
#+ force_destroy        = false
#+ id                   = (known after apply)
#+ name                 = "trinity"
#+ path                 = "/"
#+ permissions_boundary = null
#+ tags                 = null
#+ tags_all             = (known after apply)
#+ unique_id            = (known after apply)
#}
#}

output "all_users04_2" {
  value = values(aws_iam_user.example04)[*].arn
}
# ✨✨✨✨✨ plan 결과 ✨✨✨✨✨
#+ all_users04_2 = [
#+ (known after apply),
#+ (known after apply),
#+ (known after apply),
#]
