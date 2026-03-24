resource "aws_security_group" "main" {
  name        = "${var.project_name}-${var.environment}-${var.security_group_name}-sg"
  description = var.security_group_description
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-${var.environment}-${var.security_group_name}-sg"
      Environment = var.environment
      Project     = var.project_name
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# -------------------------
# Ingress Rules
# -------------------------
resource "aws_security_group_rule" "ingress" {
  count = length(var.ingress_rules)

  type              = "ingress"
  security_group_id = aws_security_group.main.id

  description = var.ingress_rules[count.index].description
  from_port   = var.ingress_rules[count.index].from_port
  to_port     = var.ingress_rules[count.index].to_port
  protocol    = var.ingress_rules[count.index].protocol

  # IMPORTANT: set to null when not used (prevents conflicts)
  cidr_blocks      = try(var.ingress_rules[count.index].cidr_blocks, null)
  ipv6_cidr_blocks = try(var.ingress_rules[count.index].ipv6_cidr_blocks, null)
  prefix_list_ids  = try(var.ingress_rules[count.index].prefix_list_ids, null)

  source_security_group_id = try(var.ingress_rules[count.index].source_security_group_id, null)

  # Only set self when it is true, otherwise keep null
  self = try(var.ingress_rules[count.index].self, null) == true ? true : null
}

# -------------------------
# Egress Rules
# -------------------------
resource "aws_security_group_rule" "egress" {
  count = length(var.egress_rules)

  type              = "egress"
  security_group_id = aws_security_group.main.id

  description = var.egress_rules[count.index].description
  from_port   = var.egress_rules[count.index].from_port
  to_port     = var.egress_rules[count.index].to_port
  protocol    = var.egress_rules[count.index].protocol

  # IMPORTANT: set to null when not used (prevents conflicts)
  cidr_blocks      = try(var.egress_rules[count.index].cidr_blocks, null)
  ipv6_cidr_blocks = try(var.egress_rules[count.index].ipv6_cidr_blocks, null)
  prefix_list_ids  = try(var.egress_rules[count.index].prefix_list_ids, null)

  # AWS resource uses source_security_group_id even for egress-to-sg
  source_security_group_id = try(var.egress_rules[count.index].destination_security_group_id, null)
}