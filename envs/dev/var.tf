variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

# VPC Variables
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "availability_zone_1" {
  description = "First availability zone"
  type        = string
}

variable "availability_zone_2" {
  description = "Second availability zone"
  type        = string
}

variable "public_subnet_az1_cidr" {
  description = "Public subnet AZ1 CIDR"
  type        = string
}

variable "public_subnet_az2_cidr" {
  description = "Public subnet AZ2 CIDR"
  type        = string
}

variable "private_subnet_az1_cidr" {
  description = "Private subnet AZ1 CIDR"
  type        = string
}

variable "private_subnet_az2_cidr" {
  description = "Private subnet AZ2 CIDR"
  type        = string
}

# ECS Variables
variable "container_port" {
  description = "Container port"
  type        = number
  default     = 8080
}

variable "ecs_cpu" {
  description = "ECS task CPU units"
  type        = number
  default     = 256
}

variable "ecs_memory" {
  description = "ECS task memory in MiB"
  type        = number
  default     = 512
}

variable "ecs_desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
}

variable "health_check_path" {
  description = "Health check path for target group"
  type        = string
  default     = "/health"
}

# SSL Certificate (for QA - optional in dev)
variable "ssl_certificate_arn" {
  description = "SSL certificate ARN for HTTPS"
  type        = string
  default     = ""
}