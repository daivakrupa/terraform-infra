# -------------------------
# ECS Service
# -------------------------
resource "aws_ecs_service" "main" {
  name                               = "${var.project_name}-${var.environment}-${var.service_name}"
  cluster                            = var.cluster_arn
  task_definition                    = var.task_definition_arn
  desired_count                      = var.desired_count
  launch_type                        = var.launch_type
  platform_version                   = var.launch_type == "FARGATE" ? var.platform_version : null
  scheduling_strategy                = var.scheduling_strategy
  force_new_deployment               = var.force_new_deployment
  enable_execute_command             = var.enable_execute_command
  health_check_grace_period_seconds  = var.enable_load_balancer ? var.health_check_grace_period_seconds : null

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = var.assign_public_ip
  }

  dynamic "load_balancer" {
    for_each = var.enable_load_balancer && var.target_group_arn != "" ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

#   deployment_configuration {
#     minimum_healthy_percent = var.deployment_minimum_healthy_percent
#     maximum_percent         = var.deployment_maximum_percent

#     deployment_circuit_breaker {
#       enable   = var.enable_circuit_breaker
#       rollback = var.enable_circuit_breaker_rollback
#     }
#   }

  dynamic "service_registries" {
    for_each = var.enable_service_discovery ? [1] : []
    content {
      registry_arn = aws_service_discovery_service.main[0].arn
    }
  }

  wait_for_steady_state = var.wait_for_steady_state

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-${var.environment}-${var.service_name}"
      Environment = var.environment
      Project     = var.project_name
    }
  )

  lifecycle {
    ignore_changes = [desired_count]
  }
}

# -------------------------
# Service Discovery Service (Optional)
# -------------------------
resource "aws_service_discovery_service" "main" {
  count = var.enable_service_discovery ? 1 : 0

  name = var.service_name

  dns_config {
    namespace_id = var.service_discovery_namespace_id

    dns_records {
      ttl  = var.service_discovery_dns_ttl
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

#   health_check_custom_config {
#     failure_threshold = 1
#   }

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-${var.environment}-${var.service_name}-discovery"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}