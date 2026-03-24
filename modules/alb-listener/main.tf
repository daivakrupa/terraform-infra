# -------------------------
# HTTP Listener (Redirect to HTTPS)
# -------------------------
resource "aws_lb_listener" "http_redirect" {
  count = var.enable_http_listener && var.http_action_type == "redirect" ? 1 : 0

  load_balancer_arn = var.alb_arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-${var.environment}-http-listener"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

# -------------------------
# HTTP Listener (Forward)
# -------------------------
resource "aws_lb_listener" "http_forward" {
  count = var.enable_http_listener && var.http_action_type == "forward" ? 1 : 0

  load_balancer_arn = var.alb_arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-${var.environment}-http-listener"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

# -------------------------
# HTTPS Listener
# -------------------------
resource "aws_lb_listener" "https" {
  count = var.enable_https_listener && var.ssl_certificate_arn != "" ? 1 : 0

  load_balancer_arn = var.alb_arn
  port              = var.https_port
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.ssl_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-${var.environment}-https-listener"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}