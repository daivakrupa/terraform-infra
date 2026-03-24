# -------------------------
# ECS Service Outputs
# -------------------------
output "service_id" {
  description = "The ID of the ECS service"
  value       = aws_ecs_service.main.id
}

output "service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.main.name
}

output "service_cluster" {
  description = "The cluster of the ECS service"
  value       = aws_ecs_service.main.cluster
}

output "service_desired_count" {
  description = "The desired count of the ECS service"
  value       = aws_ecs_service.main.desired_count
}

output "service_discovery_arn" {
  description = "The ARN of the service discovery service"
  value       = var.enable_service_discovery ? aws_service_discovery_service.main[0].arn : null
}