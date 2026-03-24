aws_region   = "us-east-1"
project_name = "myapp"
environment  = "shared"

state_bucket_name    = "myapp-terraform-state-2026-v1"
dynamodb_table_name  = "myapp-terraform-lock"

sse_algorithm = "AES256"
force_destroy = false

common_tags = {
  Owner      = "platform-team"
  CostCenter = "engineering"
}