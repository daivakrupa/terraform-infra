aws_region   = "us-east-1"
project_name = "myapp"
environment  = "qa"

# VPC Configuration (DIFFERENT CIDR from dev to avoid overlap)
vpc_cidr            = "10.1.0.0/16"
availability_zone_1 = "us-east-1a"
availability_zone_2 = "us-east-1b"

public_subnet_az1_cidr  = "10.1.1.0/24"
public_subnet_az2_cidr  = "10.1.2.0/24"
private_subnet_az1_cidr = "10.1.10.0/24"
private_subnet_az2_cidr = "10.1.11.0/24"

# ECS Configuration (HIGHER SPECS FOR QA)
container_port    = 8000
ecs_cpu           = 512
ecs_memory        = 1024
ecs_desired_count = 2
health_check_path = "/health"

# SSL Certificate (replace with your actual certificate ARN)
ssl_certificate_arn = ""