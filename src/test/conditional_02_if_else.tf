variable "name" {
  description = "A name to render"
  type = string
}

output "if_else_directive" {
  value = "Hello, %{ if var.name != "" }${var.name}%{ else }(unnamed)%{ endif }"
}

# terraform apply -var name = "World"
# 결과:
# if_else_directive = Hello, World

# terraform apply -var name = ""
# 결과:
# if_else_directive = Hello, (unnamed)