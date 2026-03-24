terraform {
  backend "s3" {
    bucket         = "myapp-terraform-state-2026-v1"
    key            = "qa/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "myapp-terraform-lock"
  }
}

provider "aws" {
  region = var.aws_region
}

# ============================================
# LOCAL VARIABLES
# ============================================
locals {
  common_tags = {
    Owner      = "platform-team"
    CostCenter = "qa-testing"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

# ============================================
# VPC NETWORKING
# ============================================
module "vpc" {
  source = "../../modules/vpc"

  project_name           = var.project_name
  environment            = var.environment
  common_tags            = local.common_tags
  vpc_cidr               = var.vpc_cidr
  availability_zone_1    = var.availability_zone_1
  availability_zone_2    = var.availability_zone_2
  public_subnet_az1_cidr = var.public_subnet_az1_cidr
  public_subnet_az2_cidr = var.public_subnet_az2_cidr
  private_subnet_az1_cidr = var.private_subnet_az1_cidr
  private_subnet_az2_cidr = var.private_subnet_az2_cidr
  map_public_ip_on_launch = true
  enable_nat_gateway      = true
}

# ============================================
# SECURITY GROUPS
# ============================================
module "sg_alb" {
  source = "../../modules/security-group"

  project_name               = var.project_name
  environment                = var.environment
  common_tags                = local.common_tags
  vpc_id                     = module.vpc.vpc_id
  security_group_name        = "alb"
  security_group_description = "Security group for Application Load Balancer"

  ingress_rules = [
    {
      description = "Allow HTTP from anywhere"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTPS from anywhere"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "sg_ecs" {
  source = "../../modules/security-group"

  project_name               = var.project_name
  environment                = var.environment
  common_tags                = local.common_tags
  vpc_id                     = module.vpc.vpc_id
  security_group_name        = "ecs"
  security_group_description = "Security group for ECS Fargate tasks"

  ingress_rules = [
    {
      description              = "Allow traffic from ALB security group"
      from_port                = var.container_port
      to_port                  = var.container_port
      protocol                 = "tcp"
      source_security_group_id = module.sg_alb.security_group_id
    }
  ]
}

# ============================================
# IAM ROLES
# ============================================
module "ecs_task_execution_role" {
  source = "../../modules/iam-role"

  project_name = var.project_name
  environment  = var.environment
  common_tags  = local.common_tags
  role_name    = "ecs-task-execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}

module "ecs_task_role" {
  source = "../../modules/iam-role"

  project_name = var.project_name
  environment  = var.environment
  common_tags  = local.common_tags
  role_name    = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })

  inline_policies = {
    app_secrets = {
      policy_document = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "ssm:GetParameter",
              "ssm:GetParameters",
              "ssm:GetParametersByPath"
            ]
            Resource = "*"
          },
          {
            Effect = "Allow"
            Action = [
              "secretsmanager:GetSecretValue"
            ]
            Resource = "*"
          }
        ]
      })
    }
  }
}
# ============================================
# CONTAINER REGISTRY (ECR)
# ============================================
module "ecr" {
  source = "../../modules/ecr"

  project_name         = var.project_name
  environment          = var.environment
  common_tags          = local.common_tags
  repository_name      = "backend-api"
  scan_on_push         = true
  image_tag_mutability = "MUTABLE"
}

# ============================================
# APPLICATION LOAD BALANCER
# ============================================
module "alb" {
  source = "../../modules/alb"

  project_name       = var.project_name
  environment        = var.environment
  common_tags        = local.common_tags
  alb_name           = "backend-alb"
  internal           = false
  security_group_ids = [module.sg_alb.security_group_id]
  subnet_ids         = module.vpc.public_subnet_ids
}

# ============================================
# TARGET GROUP
# ============================================
module "target_group" {
  source = "../../modules/target-group"

  project_name        = var.project_name
  environment         = var.environment
  common_tags         = local.common_tags
  target_group_name   = "backend-tg"
  vpc_id              = module.vpc.vpc_id
  port                = var.container_port
  protocol            = "HTTP"
  target_type         = "ip"
  health_check_path   = var.health_check_path
  health_check_matcher = "200-299"
}

# ============================================
# ALB LISTENERS (WITH HTTPS FOR QA)
# ============================================
module "alb_listener" {
  source = "../../modules/alb-listener"

  project_name          = var.project_name
  environment           = var.environment
  common_tags           = local.common_tags
  alb_arn               = module.alb.alb_arn
  target_group_arn      = module.target_group.target_group_arn
  enable_http_listener  = true
  http_action_type      = "redirect"  # QA: Redirect HTTP to HTTPS
  enable_https_listener = true
  ssl_certificate_arn   = var.ssl_certificate_arn  # QA: Use real certificate
}

# ============================================
# ECS CLUSTER
# ============================================
module "ecs_cluster" {
  source = "../../modules/ecs-cluster"

  project_name              = var.project_name
  environment               = var.environment
  common_tags               = local.common_tags
  cluster_name              = "main"
  enable_container_insights = true
}

# ============================================
# CLOUDWATCH LOG GROUP FOR ECS TASKS
# ============================================
resource "aws_cloudwatch_log_group" "ecs_tasks" {
  name              = "/ecs/${var.project_name}-${var.environment}/backend-api"
  retention_in_days = 30  # QA: 30 days retention

  tags = merge(local.common_tags, {
    Name        = "${var.project_name}-${var.environment}-ecs-logs"
    Environment = var.environment
    Project     = var.project_name
  })
}

# ============================================
# ECS TASK DEFINITION
# ============================================
module "ecs_task_definition" {
  source = "../../modules/ecs-task-definition"

  project_name       = var.project_name
  environment        = var.environment
  common_tags        = local.common_tags
  task_family        = "backend-api"
  execution_role_arn = module.ecs_task_execution_role.role_arn
  task_role_arn      = module.ecs_task_role.role_arn
  cpu                = var.ecs_cpu
  memory             = var.ecs_memory
  container_name     = "backend-api"
  container_image    = "${module.ecr.repository_url}:latest"
  container_port     = var.container_port
  log_group_name     = aws_cloudwatch_log_group.ecs_tasks.name
  aws_region         = var.aws_region

  environment_variables = [
    { name = "ENV", value = var.environment },
    { name = "PORT", value = tostring(var.container_port) }
  ]
}

# ============================================
# ECS SERVICE (WITH HIGHER COUNT FOR QA)
# ============================================
module "ecs_service" {
  source = "../../modules/ecs-service"

  project_name                     = var.project_name
  environment                      = var.environment
  common_tags                      = local.common_tags
  service_name                     = "backend-api"
  cluster_arn                      = module.ecs_cluster.cluster_arn
  task_definition_arn              = module.ecs_task_definition.task_definition_arn
  desired_count                    = var.ecs_desired_count
  subnet_ids                       = module.vpc.private_subnet_ids
  security_group_ids               = [module.sg_ecs.security_group_id]
  assign_public_ip                 = false
  target_group_arn                 = module.target_group.target_group_arn
  container_name                   = "backend-api"
  container_port                   = var.container_port
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
}

# ============================================
# FRONTEND: S3 BUCKET
# ============================================
module "frontend_bucket" {
  source = "../../modules/s3-bucket"

  project_name             = var.project_name
  environment              = var.environment
  common_tags              = local.common_tags
  bucket_name              = "frontend-assets"
  force_destroy            = false  # QA: Protect from accidental deletion
  enable_versioning        = true
  enable_cors              = true
  enable_cloudfront_access = true
  cloudfront_distribution_arn = module.cloudfront.distribution_arn
}

# ============================================
# FRONTEND: CLOUDFRONT (WITH CUSTOM DOMAIN)
# ============================================
module "cloudfront" {
  source = "../../modules/cloudfront"

  project_name                   = var.project_name
  environment                    = var.environment
  common_tags                    = local.common_tags
  s3_bucket_regional_domain_name = module.frontend_bucket.bucket_regional_domain_name
  s3_bucket_id                   = module.frontend_bucket.bucket_id
  default_root_object            = "index.html"
  price_class                    = "PriceClass_100"
  use_custom_ssl_certificate     = true
  acm_certificate_arn            = var.ssl_certificate_arn
  aliases                        = ["app.qa.myapp.com"]  # QA custom domain
}