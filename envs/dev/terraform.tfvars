aws_region   = "us-east-1"
project_name = "myapp"
environment  = "dev"

# VPC Configuration
vpc_cidr            = "10.0.0.0/16"
availability_zone_1 = "us-east-1a"
availability_zone_2 = "us-east-1b"

public_subnet_az1_cidr  = "10.0.1.0/24"
public_subnet_az2_cidr  = "10.0.2.0/24"
private_subnet_az1_cidr = "10.0.10.0/24"
private_subnet_az2_cidr = "10.0.11.0/24"

# ECS Configuration
container_port    = 8000
ecs_cpu           = 256
ecs_memory        = 512
ecs_desired_count = 1
health_check_path = "/health"

# SSL (empty for dev - uses HTTP only)
ssl_certificate_arn = ""