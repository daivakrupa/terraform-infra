# -------------------------
# IAM Role Outputs
# -------------------------
output "role_id" {
  description = "The ID of the IAM role"
  value       = aws_iam_role.main.id
}

output "role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.main.arn
}

output "role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.main.name
}

output "role_unique_id" {
  description = "The unique ID of the IAM role"
  value       = aws_iam_role.main.unique_id
}