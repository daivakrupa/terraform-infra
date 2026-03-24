# -------------------------
# Task Definition Outputs
# -------------------------
output "task_definition_arn" {
  description = "The ARN of the task definition"
  value       = aws_ecs_task_definition.main.arn
}

output "task_definition_arn_without_revision" {
  description = "The ARN of the task definition without revision"
  value       = replace(aws_ecs_task_definition.main.arn, "/:${aws_ecs_task_definition.main.revision}$/", "")
}

output "task_definition_family" {
  description = "The family of the task definition"
  value       = aws_ecs_task_definition.main.family
}

output "task_definition_revision" {
  description = "The revision of the task definition"
  value       = aws_ecs_task_definition.main.revision
}

output "container_name" {
  description = "The name of the container"
  value       = var.container_name
}

output "container_port" {
  description = "The port of the container"
  value       = var.container_port
}