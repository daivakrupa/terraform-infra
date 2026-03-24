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
# Listener Configuration
# -------------------------
variable "alb_arn" {
  description = "ARN of the Application Load Balancer"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the default target group"
  type        = string
}

# -------------------------
# HTTP Listener Configuration
# -------------------------
variable "enable_http_listener" {
  description = "Enable HTTP listener"
  type        = bool
  default     = true
}

variable "http_port" {
  description = "Port for HTTP listener"
  type        = number
  default     = 80
}

variable "http_action_type" {
  description = "Action type for HTTP listener (forward or redirect)"
  type        = string
  default     = "redirect"

  validation {
    condition     = contains(["forward", "redirect"], var.http_action_type)
    error_message = "HTTP action type must be forward or redirect."
  }
}

# -------------------------
# HTTPS Listener Configuration
# -------------------------
variable "enable_https_listener" {
  description = "Enable HTTPS listener"
  type        = bool
  default     = true
}

variable "https_port" {
  description = "Port for HTTPS listener"
  type        = number
  default     = 443
}

variable "ssl_certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
  default     = ""
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}