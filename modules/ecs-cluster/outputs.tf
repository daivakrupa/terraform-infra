# -------------------------
# ECS Cluster Outputs
# -------------------------
output "cluster_id" {
  description = "The ID of the ECS cluster"
  value       = aws_ecs_cluster.main.id
}

output "cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
}

output "cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "exec_log_group_name" {
  description = "The name of the CloudWatch log group for ECS Exec"
  value       = var.enable_execute_command_logging ? aws_cloudwatch_log_group.ecs_exec[0].name : null
}

output "exec_log_group_arn" {
  description = "The ARN of the CloudWatch log group for ECS Exec"
  value       = var.enable_execute_command_logging ? aws_cloudwatch_log_group.ecs_exec[0].arn : null
}