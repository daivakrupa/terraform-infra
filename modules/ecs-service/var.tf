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
# ECS Service Configuration
# -------------------------
variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "cluster_arn" {
  description = "ARN of the ECS cluster"
  type        = string
}

variable "task_definition_arn" {
  description = "ARN of the task definition"
  type        = string
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "launch_type" {
  description = "Launch type for the service"
  type        = string
  default     = "FARGATE"

  validation {
    condition     = contains(["FARGATE", "EC2", "EXTERNAL"], var.launch_type)
    error_message = "Launch type must be FARGATE, EC2, or EXTERNAL."
  }
}

variable "platform_version" {
  description = "Platform version for Fargate"
  type        = string
  default     = "LATEST"
}

variable "scheduling_strategy" {
  description = "Scheduling strategy for the service"
  type        = string
  default     = "REPLICA"

  validation {
    condition     = contains(["REPLICA", "DAEMON"], var.scheduling_strategy)
    error_message = "Scheduling strategy must be REPLICA or DAEMON."
  }
}

variable "force_new_deployment" {
  description = "Force a new deployment on every apply"
  type        = bool
  default     = false
}

variable "enable_execute_command" {
  description = "Enable ECS Exec for the service"
  type        = bool
  default     = true
}

# -------------------------
# Network Configuration
# -------------------------
variable "subnet_ids" {
  description = "List of subnet IDs for the service"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the service"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign public IP to tasks"
  type        = bool
  default     = false
}

# -------------------------
# Load Balancer Configuration
# -------------------------
variable "enable_load_balancer" {
  description = "Enable load balancer integration"
  type        = bool
  default     = true
}

variable "target_group_arn" {
  description = "ARN of the target group"
  type        = string
  default     = ""
}

variable "container_name" {
  description = "Name of the container for load balancer"
  type        = string
}

variable "container_port" {
  description = "Port of the container for load balancer"
  type        = number
}

# -------------------------
# Deployment Configuration
# -------------------------
variable "deployment_minimum_healthy_percent" {
  description = "Minimum healthy percent during deployment"
  type        = number
  default     = 100
}

variable "deployment_maximum_percent" {
  description = "Maximum percent during deployment"
  type        = number
  default     = 200
}

variable "enable_circuit_breaker" {
  description = "Enable deployment circuit breaker"
  type        = bool
  default     = true
}

variable "enable_circuit_breaker_rollback" {
  description = "Enable rollback on deployment circuit breaker"
  type        = bool
  default     = true
}

variable "wait_for_steady_state" {
  description = "Wait for the service to reach a steady state"
  type        = bool
  default     = false
}

# -------------------------
# Health Check Grace Period
# -------------------------
variable "health_check_grace_period_seconds" {
  description = "Health check grace period in seconds"
  type        = number
  default     = 60
}

# -------------------------
# Service Discovery (Optional)
# -------------------------
variable "enable_service_discovery" {
  description = "Enable service discovery"
  type        = bool
  default     = false
}

variable "service_discovery_namespace_id" {
  description = "Service discovery namespace ID"
  type        = string
  default     = ""
}

variable "service_discovery_dns_ttl" {
  description = "Service discovery DNS record TTL"
  type        = number
  default     = 10
}