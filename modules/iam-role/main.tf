# -------------------------
# IAM Role
# -------------------------
resource "aws_iam_role" "main" {
  name                  = "${var.project_name}-${var.environment}-${var.role_name}"
  description           = var.role_description
  assume_role_policy    = var.assume_role_policy
  max_session_duration  = var.max_session_duration
  force_detach_policies = var.force_detach_policies

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-${var.environment}-${var.role_name}"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

# -------------------------
# Managed Policy Attachments
# -------------------------
resource "aws_iam_role_policy_attachment" "managed" {
  count = length(var.managed_policy_arns)

  role       = aws_iam_role.main.name
  policy_arn = var.managed_policy_arns[count.index]
}

# -------------------------
# Inline Policies
# -------------------------
resource "aws_iam_role_policy" "inline" {
  for_each = var.inline_policies

  name   = "${var.project_name}-${var.environment}-${each.key}"
  role   = aws_iam_role.main.id
  policy = each.value.policy_document
}