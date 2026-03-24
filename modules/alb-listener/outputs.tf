# -------------------------
# Listener Outputs
# -------------------------
output "http_listener_arn" {
  description = "The ARN of the HTTP listener"
  value       = var.http_action_type == "redirect" ? (length(aws_lb_listener.http_redirect) > 0 ? aws_lb_listener.http_redirect[0].arn : null) : (length(aws_lb_listener.http_forward) > 0 ? aws_lb_listener.http_forward[0].arn : null)
}

output "https_listener_arn" {
  description = "The ARN of the HTTPS listener"
  value       = length(aws_lb_listener.https) > 0 ? aws_lb_listener.https[0].arn : null
}