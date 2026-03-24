# -------------------------
# Target Group Outputs
# -------------------------
output "target_group_id" {
  description = "The ID of the target group"
  value       = aws_lb_target_group.main.id
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.main.arn
}

output "target_group_arn_suffix" {
  description = "The ARN suffix of the target group"
  value       = aws_lb_target_group.main.arn_suffix
}

output "target_group_name" {
  description = "The name of the target group"
  value       = aws_lb_target_group.main.name
}