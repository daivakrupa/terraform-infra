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
# CloudFront Distribution Configuration
# -------------------------
variable "distribution_comment" {
  description = "Comment for the CloudFront distribution"
  type        = string
  default     = ""
}

variable "enabled" {
  description = "Whether the distribution is enabled"
  type        = bool
  default     = true
}

variable "is_ipv6_enabled" {
  description = "Whether IPv6 is enabled"
  type        = bool
  default     = true
}

variable "http_version" {
  description = "HTTP version for the distribution"
  type        = string
  default     = "http2and3"

  validation {
    condition     = contains(["http1.1", "http2", "http2and3", "http3"], var.http_version)
    error_message = "HTTP version must be http1.1, http2, http2and3, or http3."
  }
}

variable "default_root_object" {
  description = "Default root object"
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "Price class for the distribution"
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.price_class)
    error_message = "Price class must be PriceClass_All, PriceClass_200, or PriceClass_100."
  }
}

variable "wait_for_deployment" {
  description = "Wait for distribution deployment"
  type        = bool
  default     = false
}

# -------------------------
# S3 Origin Configuration
# -------------------------
variable "s3_bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  type        = string
}

variable "s3_bucket_id" {
  description = "ID of the S3 bucket"
  type        = string
}

# -------------------------
# Origin Access Control Configuration
# -------------------------
variable "origin_access_control_name" {
  description = "Name for the Origin Access Control"
  type        = string
  default     = "s3-oac"
}

# -------------------------
# Cache Behavior Configuration
# -------------------------
variable "allowed_methods" {
  description = "Allowed HTTP methods"
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "cached_methods" {
  description = "Cached HTTP methods"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "viewer_protocol_policy" {
  description = "Protocol policy for viewers"
  type        = string
  default     = "redirect-to-https"

  validation {
    condition     = contains(["allow-all", "https-only", "redirect-to-https"], var.viewer_protocol_policy)
    error_message = "Viewer protocol policy must be allow-all, https-only, or redirect-to-https."
  }
}

variable "compress" {
  description = "Enable compression"
  type        = bool
  default     = true
}

variable "default_ttl" {
  description = "Default TTL in seconds"
  type        = number
  default     = 3600
}

variable "min_ttl" {
  description = "Minimum TTL in seconds"
  type        = number
  default     = 0
}

variable "max_ttl" {
  description = "Maximum TTL in seconds"
  type        = number
  default     = 86400
}

# -------------------------
# SSL Certificate Configuration
# -------------------------
variable "use_custom_ssl_certificate" {
  description = "Use custom SSL certificate"
  type        = bool
  default     = false
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate (must be in us-east-1)"
  type        = string
  default     = ""
}

variable "ssl_support_method" {
  description = "SSL support method (sni-only or vip)"
  type        = string
  default     = "sni-only"
}

variable "minimum_protocol_version" {
  description = "Minimum TLS protocol version"
  type        = string
  default     = "TLSv1.2_2021"
}

# -------------------------
# Domain Configuration
# -------------------------
variable "aliases" {
  description = "Alternate domain names (CNAMEs)"
  type        = list(string)
  default     = []
}

# -------------------------
# Custom Error Response Configuration
# -------------------------
variable "custom_error_responses" {
  description = "Custom error responses for SPA routing"
  type = list(object({
    error_code            = number
    response_code         = number
    response_page_path    = string
    error_caching_min_ttl = number
  }))
  default = [
    {
      error_code            = 403
      response_code         = 200
      response_page_path    = "/index.html"
      error_caching_min_ttl = 10
    },
    {
      error_code            = 404
      response_code         = 200
      response_page_path    = "/index.html"
      error_caching_min_ttl = 10
    }
  ]
}

# -------------------------
# Geo Restriction Configuration
# -------------------------
variable "geo_restriction_type" {
  description = "Geo restriction type (none, whitelist, blacklist)"
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "whitelist", "blacklist"], var.geo_restriction_type)
    error_message = "Geo restriction type must be none, whitelist, or blacklist."
  }
}

variable "geo_restriction_locations" {
  description = "List of country codes for geo restriction"
  type        = list(string)
  default     = []
}

# -------------------------
# Logging Configuration
# -------------------------
variable "enable_logging" {
  description = "Enable CloudFront access logging"
  type        = bool
  default     = false
}

variable "logging_bucket" {
  description = "S3 bucket for access logs"
  type        = string
  default     = ""
}

variable "logging_prefix" {
  description = "Prefix for access logs"
  type        = string
  default     = "cloudfront-logs/"
}