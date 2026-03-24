# -------------------------
# Local Variables
# -------------------------
locals {
  s3_origin_id = "${var.project_name}-${var.environment}-s3-origin"
}

# -------------------------
# CloudFront Origin Access Control
# -------------------------
resource "aws_cloudfront_origin_access_control" "main" {
  name                              = "${var.project_name}-${var.environment}-${var.origin_access_control_name}"
  description                       = "Origin Access Control for ${var.project_name}-${var.environment}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# -------------------------
# CloudFront Distribution
# -------------------------
resource "aws_cloudfront_distribution" "main" {
  comment             = var.distribution_comment != "" ? var.distribution_comment : "${var.project_name}-${var.environment} distribution"
  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  http_version        = var.http_version
  default_root_object = var.default_root_object
  price_class         = var.price_class
  aliases             = var.aliases
  wait_for_deployment = var.wait_for_deployment

  origin {
    domain_name              = var.s3_bucket_regional_domain_name
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
  }

  default_cache_behavior {
    target_origin_id       = local.s3_origin_id
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    viewer_protocol_policy = var.viewer_protocol_policy
    compress               = var.compress

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = var.min_ttl
    default_ttl = var.default_ttl
    max_ttl     = var.max_ttl
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = !var.use_custom_ssl_certificate
    acm_certificate_arn            = var.use_custom_ssl_certificate ? var.acm_certificate_arn : null
    ssl_support_method             = var.use_custom_ssl_certificate ? var.ssl_support_method : null
    minimum_protocol_version       = var.use_custom_ssl_certificate ? var.minimum_protocol_version : null
  }

  dynamic "logging_config" {
    for_each = var.enable_logging ? [1] : []
    content {
      bucket          = var.logging_bucket
      prefix          = var.logging_prefix
      include_cookies = false
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-${var.environment}-cloudfront"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}