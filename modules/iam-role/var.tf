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
# IAM Role Configuration
# -------------------------
variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "role_description" {
  description = "Description of the IAM role"
  type        = string
  default     = "Managed by Terraform"
}

variable "assume_role_policy" {
  description = "The assume role policy document (JSON)"
  type        = string
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds"
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "Max session duration must be between 3600 and 43200 seconds."
  }
}

variable "force_detach_policies" {
  description = "Force detach policies before destroying the role"
  type        = bool
  default     = true
}

# -------------------------
# IAM Policy Attachments
# -------------------------
variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach"
  type        = list(string)
  default     = []
}

# -------------------------
# Inline Policies
# -------------------------
variable "inline_policies" {
  description = "Map of inline policies to attach"
  type = map(object({
    policy_document = string
  }))
  default = {}
}