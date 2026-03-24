# -------------------------
# CloudWatch Log Group for ECS Exec
# -------------------------
resource "aws_cloudwatch_log_group" "ecs_exec" {
  count = var.enable_execute_command_logging ? 1 : 0

  name              = "/aws/ecs/${var.project_name}-${var.environment}-${var.cluster_name}/exec"
  retention_in_days = var.log_retention_days

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-${var.environment}-${var.cluster_name}-exec-logs"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

# -------------------------
# ECS Cluster
# -------------------------
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-${var.environment}-${var.cluster_name}"

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  dynamic "configuration" {
    for_each = var.enable_execute_command_logging ? [1] : []
    content {
      execute_command_configuration {
        logging = "OVERRIDE"

        log_configuration {
          cloud_watch_log_group_name = aws_cloudwatch_log_group.ecs_exec[0].name
        }
      }
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-${var.environment}-${var.cluster_name}"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

# -------------------------
# ECS Cluster Capacity Providers
# -------------------------
resource "aws_ecs_cluster_capacity_providers" "main" {
  count = var.enable_fargate_capacity_providers ? 1 : 0

  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = var.default_capacity_provider
  }
}