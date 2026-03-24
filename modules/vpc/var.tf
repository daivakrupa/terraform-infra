# -------------------------
# Project Configuration
# -------------------------
variable "project_name" {
  description = "Name of the project"
  type        = string

  validation {
    condition     = length(var.project_name) > 0 && length(var.project_name) <= 32
    error_message = "Project name must be between 1 and 32 characters."
  }
}

variable "environment" {
  description = "Environment name (dev, qa, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "qa", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, qa, staging, prod."
  }
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# -------------------------
# VPC Configuration
# -------------------------
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

# -------------------------
# Availability Zones
# -------------------------
variable "availability_zone_1" {
  description = "First availability zone"
  type        = string
}

variable "availability_zone_2" {
  description = "Second availability zone"
  type        = string
}

# -------------------------
# Public Subnet Configuration
# -------------------------
variable "public_subnet_az1_cidr" {
  description = "CIDR block for public subnet in AZ1"
  type        = string

  validation {
    condition     = can(cidrhost(var.public_subnet_az1_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "public_subnet_az2_cidr" {
  description = "CIDR block for public subnet in AZ2"
  type        = string

  validation {
    condition     = can(cidrhost(var.public_subnet_az2_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "map_public_ip_on_launch" {
  description = "Auto-assign public IP on launch for public subnets"
  type        = bool
  default     = true
}

# -------------------------
# Private Subnet Configuration
# -------------------------
variable "private_subnet_az1_cidr" {
  description = "CIDR block for private subnet in AZ1"
  type        = string

  validation {
    condition     = can(cidrhost(var.private_subnet_az1_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "private_subnet_az2_cidr" {
  description = "CIDR block for private subnet in AZ2"
  type        = string

  validation {
    condition     = can(cidrhost(var.private_subnet_az2_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

# -------------------------
# NAT Gateway Configuration
# -------------------------
variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}