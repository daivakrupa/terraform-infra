output "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.state.id
}

output "state_bucket_arn" {
  description = "ARN of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.state.arn
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  value       = aws_dynamodb_table.state_lock.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.state_lock.arn
}

output "kms_key_arn" {
  description = "ARN of the KMS key for state encryption"
  value       = aws_kms_key.state.arn
}

output "kms_key_alias" {
  description = "Alias of the KMS key"
  value       = aws_kms_alias.state.name
}

# Backend config block for copy-paste
output "backend_config" {
  description = "Backend configuration block to copy into environment main.tf"
  value = <<-EOT
    terraform {
      backend "s3" {
        bucket         = "${aws_s3_bucket.state.id}"
        key            = "<environment>/terraform.tfstate"
        region         = ${data.aws_region.current.name}
        encrypt        = true
        dynamodb_table = "${aws_dynamodb_table.state_lock.name}"
        kms_key_id     = "${aws_kms_key.state.arn}"
      }
    }
  EOT
}