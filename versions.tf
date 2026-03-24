# versions.tf
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=5.84.0"  # Pin exact version to prevent breaking changes
    }
  }
}