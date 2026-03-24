# -------------------------
# Local Variables
# -------------------------
locals {
  container_definition = {
    name      = var.container_name
    image     = var.container_image
    cpu       = var.container_cpu
    memory    = var.container_memory
    memoryReservation = var.container_memory_reservation
    essential = var.essential

    portMappings = [
      {
        containerPort = var.container_port
        hostPort      = var.host_port != null ? var.host_port : var.container_port
        protocol      = "tcp"
      }
    ]

    environment = var.environment_variables
    secrets     = var.secrets

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = var.log_group_name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = var.log_stream_prefix
      }
    }

    healthCheck = var.health_check_command != null ? {
      command     = var.health_check_command
      interval    = var.health_check_interval
      timeout     = var.health_check_timeout
      retries     = var.health_check_retries
      startPeriod = var.health_check_start_period
    } : null
  }
}

# -------------------------
# ECS Task Definition
# -------------------------
resource "aws_ecs_task_definition" "main" {
  family                   = "${var.project_name}-${var.environment}-${var.task_family}"
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  runtime_platform {
    operating_system_family = var.operating_system_family
    cpu_architecture        = var.cpu_architecture
  }

  container_definitions = jsonencode([local.container_definition])

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-${var.environment}-${var.task_family}"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}