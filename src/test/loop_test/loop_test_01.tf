resource "aws_iam_user" "example01" {
  count = 3
  name = "neo"
}

# ✨✨✨✨✨ plan 결과 ✨✨✨✨✨
# aws_iam_user.example[0] will be created
#+ resource "aws_iam_user" "example" {
#+ arn           = (known after apply)
#+ force_destroy = false
#+ id            = (known after apply)
#+ name          = "neo"
#+ path          = "/"
#+ tags_all      = (known after apply)
#+ unique_id     = (known after apply)
#}
#
## aws_iam_user.example[1] will be created
#+ resource "aws_iam_user" "example" {
#+ arn           = (known after apply)
#+ force_destroy = false
#+ id            = (known after apply)
#+ name          = "neo"
#+ path          = "/"
#+ tags_all      = (known after apply)
#+ unique_id     = (known after apply)
#}
#
## aws_iam_user.example[2] will be created
#+ resource "aws_iam_user" "example" {
#+ arn           = (known after apply)
#+ force_destroy = false
#+ id            = (known after apply)
#+ name          = "neo"
#+ path          = "/"
#+ tags_all      = (known after apply)
#+ unique_id     = (known after apply)
#}


#######################################################################


resource "aws_iam_user" "example02" {
  count = 3
  name = "neo.${count.index}"
}

# ✨✨✨✨✨ plan 결과 ✨✨✨✨✨
## aws_iam_user.example02[0] will be created
#+ resource "aws_iam_user" "example02" {
#+ arn           = (known after apply)
#+ force_destroy = false
#+ id            = (known after apply)
#+ name          = "neo.0"
#+ path          = "/"
#+ tags_all      = (known after apply)
#+ unique_id     = (known after apply)
#}
#
## aws_iam_user.example02[1] will be created
#+ resource "aws_iam_user" "example02" {
#+ arn           = (known after apply)
#+ force_destroy = false
#+ id            = (known after apply)
#+ name          = "neo.1"
#+ path          = "/"
#+ tags_all      = (known after apply)
#+ unique_id     = (known after apply)
#}
#
## aws_iam_user.example02[2] will be created
#+ resource "aws_iam_user" "example02" {
#+ arn           = (known after apply)
#+ force_destroy = false
#+ id            = (known after apply)
#+ name          = "neo.2"
#+ path          = "/"
#+ tags_all      = (known after apply)
#+ unique_id     = (known after apply)
#}


#######################################################################


variable "user_names" {
  description = "Create IAM users with these names"
  type = list(string)
  default = ["neo", "trinity", "morpheus"]
}

resource "aws_iam_user" "example03" {
  count = length(var.user_names)
  name = var.user_names[count.index]
}

# ✨✨✨✨✨ plan 결과 ✨✨✨✨✨
## aws_iam_user.example03[0] will be created
#+ resource "aws_iam_user" "example03" {
#+ arn           = (known after apply)
#+ force_destroy = false
#+ id            = (known after apply)
#+ name          = "neo"
#+ path          = "/"
#+ tags_all      = (known after apply)
#+ unique_id     = (known after apply)
#}
#
## aws_iam_user.example03[1] will be created
#+ resource "aws_iam_user" "example03" {
#+ arn           = (known after apply)
#+ force_destroy = false
#+ id            = (known after apply)
#+ name          = "trinity"
#+ path          = "/"
#+ tags_all      = (known after apply)
#+ unique_id     = (known after apply)
#}
#
## aws_iam_user.example03[2] will be created
#+ resource "aws_iam_user" "example03" {
#+ arn           = (known after apply)
#+ force_destroy = false
#+ id            = (known after apply)
#+ name          = "morpheus"
#+ path          = "/"
#+ tags_all      = (known after apply)
#+ unique_id     = (known after apply)
#}

output "neo_arn" {
  value = aws_iam_user.example03[0].arn
  description = "Neo 유저의 ARN 조회"
}
# ✨✨✨✨✨ plan 결과 ✨✨✨✨✨
#+ neo_arn  = (known after apply)

output "all_arns" {
  value = aws_iam_user.example03[*].arn
  description = "전체 유저의 ARN 조회"
}
# ✨✨✨✨✨ plan 결과 ✨✨✨✨✨
#+ all_arns = [
#+ (known after apply),
#+ (known after apply),
#+ (known after apply),
#]
