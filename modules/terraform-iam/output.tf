// use this to attach additional policy
output "read-only-role-name" {
  value = aws_iam_role.read-only.name
}

output "apply-name" {
  value = aws_iam_role.read-only.name
}