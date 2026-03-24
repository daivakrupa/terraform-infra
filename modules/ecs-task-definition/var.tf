# -------------------------
# Project Configuration
# -------------------------
variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, qa, staging, prod)"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# -------------------------
# Task Definition Configuration
# -------------------------
variable "task_family" {
  description = "Family name for the task definition"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the task role"
  type        = string
  default     = null
}

variable "network_mode" {
  description = "Network mode for the task"
  type        = string
  default     = "awsvpc"
}

variable "requires_compatibilities" {
  description = "Set of launch types required by the task"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "cpu" {
  description = "CPU units for the task (256, 512, 1024, 2048, 4096)"
  type        = number
  default     = 256

  validation {
    condition     = contains([256, 512, 1024, 2048, 4096], var.cpu)
    error_message = "CPU must be one of: 256, 512, 1024, 2048, 4096."
  }
}

variable "memory" {
  description = "Memory for the task in MiB"
  type        = number
  default     = 512

  validation {
    condition     = var.memory >= 512 && var.memory <= 30720
    error_message = "Memory must be between 512 and 30720 MiB."
  }
}

variable "operating_system_family" {
  description = "Operating system family for Fargate tasks"
  type        = string
  default     = "LINUX"

  validation {
    condition     = contains(["LINUX", "WINDOWS_SERVER_2019_FULL", "WINDOWS_SERVER_2019_CORE", "WINDOWS_SERVER_2022_FULL", "WINDOWS_SERVER_2022_CORE"], var.operating_system_family)
    error_message = "Invalid operating system family."
  }
}

variable "cpu_architecture" {
  description = "CPU architecture for Fargate tasks"
  type        = string
  default     = "X86_64"

  validation {
    condition     = contains(["X86_64", "ARM64"], var.cpu_architecture)
    error_message = "CPU architecture must be X86_64 or ARM64."
  }
}

# -------------------------
# Container Configuration
# -------------------------
variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_image" {
  description = "Docker image for the container"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 8080
}

variable "host_port" {
  description = "Port on the host (same as container_port for awsvpc)"
  type        = number
  default     = null
}

variable "container_cpu" {
  description = "CPU units for the container (0 = no limit)"
  type        = number
  default     = 0
}

variable "container_memory" {
  description = "Hard memory limit for the container (MiB)"
  type        = number
  default     = null
}

variable "container_memory_reservation" {
  description = "Soft memory limit for the container (MiB)"
  type        = number
  default     = null
}

variable "essential" {
  description = "Whether the container is essential"
  type        = bool
  default     = true
}

# -------------------------
# Environment Variables
# -------------------------
variable "environment_variables" {
  description = "Environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# -------------------------
# Secrets Configuration
# -------------------------
variable "secrets" {
  description = "Secrets for the container (from SSM or Secrets Manager)"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

# -------------------------
# Logging Configuration
# -------------------------
variable "log_group_name" {
  description = "CloudWatch log group name"
  type        = string
}

variable "log_stream_prefix" {
  description = "Prefix for CloudWatch log streams"
  type        = string
  default     = "ecs"
}

variable "aws_region" {
  description = "AWS region for CloudWatch logs"
  type        = string
}

# -------------------------
# Health Check Configuration
# -------------------------
variable "health_check_command" {
  description = "Health check command for the container"
  type        = list(string)
  default     = null
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "health_check_retries" {
  description = "Number of health check retries"
  type        = number
  default     = 3
}

variable "health_check_start_period" {
  description = "Health check start period in seconds"
  type        = number
  default     = 60
}