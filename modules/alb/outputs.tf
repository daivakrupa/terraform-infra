# -------------------------
# ALB Outputs
# -------------------------
output "alb_id" {
  description = "The ID of the ALB"
  value       = aws_lb.main.id
}

output "alb_arn" {
  description = "The ARN of the ALB"
  value       = aws_lb.main.arn
}

output "alb_arn_suffix" {
  description = "The ARN suffix of the ALB"
  value       = aws_lb.main.arn_suffix
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "The zone ID of the ALB"
  value       = aws_lb.main.zone_id
}

output "alb_name" {
  description = "The name of the ALB"
  value       = aws_lb.main.name
}