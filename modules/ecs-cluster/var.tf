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
# ECS Cluster Configuration
# -------------------------
variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

# -------------------------
# Container Insights Configuration
# -------------------------
variable "enable_container_insights" {
  description = "Enable Container Insights for the cluster"
  type        = bool
  default     = true
}

# -------------------------
# Capacity Providers Configuration
# -------------------------
variable "enable_fargate_capacity_providers" {
  description = "Enable Fargate capacity providers"
  type        = bool
  default     = true
}

variable "default_capacity_provider" {
  description = "Default capacity provider (FARGATE or FARGATE_SPOT)"
  type        = string
  default     = "FARGATE"

  validation {
    condition     = contains(["FARGATE", "FARGATE_SPOT"], var.default_capacity_provider)
    error_message = "Default capacity provider must be FARGATE or FARGATE_SPOT."
  }
}

# -------------------------
# Logging Configuration
# -------------------------
variable "enable_execute_command_logging" {
  description = "Enable logging for ECS Exec"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_days)
    error_message = "Log retention must be a valid CloudWatch Logs retention value."
  }
}