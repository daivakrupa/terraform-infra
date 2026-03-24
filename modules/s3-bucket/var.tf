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
# S3 Bucket Configuration
# -------------------------
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "force_destroy" {
  description = "Allow bucket deletion even if not empty"
  type        = bool
  default     = false
}

# -------------------------
# Versioning Configuration
# -------------------------
variable "enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = true
}

# -------------------------
# Encryption Configuration
# -------------------------
variable "enable_encryption" {
  description = "Enable server-side encryption"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm (AES256 or aws:kms)"
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "SSE algorithm must be AES256 or aws:kms."
  }
}

variable "kms_master_key_id" {
  description = "KMS key ID for encryption (required if sse_algorithm is aws:kms)"
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Enable S3 Bucket Keys for SSE-KMS"
  type        = bool
  default     = true
}

# -------------------------
# Public Access Configuration
# -------------------------
variable "block_public_acls" {
  description = "Block public ACLs"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public bucket policies"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict public bucket policies"
  type        = bool
  default     = true
}

# -------------------------
# Lifecycle Configuration
# -------------------------
variable "enable_lifecycle_rules" {
  description = "Enable lifecycle rules"
  type        = bool
  default     = false
}

variable "noncurrent_version_expiration_days" {
  description = "Days until noncurrent versions expire"
  type        = number
  default     = 90
}

variable "abort_incomplete_multipart_upload_days" {
  description = "Days until incomplete multipart uploads are aborted"
  type        = number
  default     = 7
}

# -------------------------
# CORS Configuration
# -------------------------
variable "enable_cors" {
  description = "Enable CORS configuration"
  type        = bool
  default     = false
}

variable "cors_allowed_headers" {
  description = "Allowed headers for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "cors_allowed_methods" {
  description = "Allowed methods for CORS"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "cors_allowed_origins" {
  description = "Allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "cors_max_age_seconds" {
  description = "Max age seconds for CORS"
  type        = number
  default     = 3600
}

# -------------------------
# CloudFront OAC Access
# -------------------------
variable "enable_cloudfront_access" {
  description = "Enable CloudFront Origin Access Control access"
  type        = bool
  default     = false
}

variable "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution for bucket policy"
  type        = string
  default     = ""
}