variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "vpc_id" {
  type = string
}

variable "security_group_name" {
  type = string
}

variable "security_group_description" {
  type    = string
  default = "Managed by Terraform"
}

# -------------------------
# Ingress Rules
# Exactly one of these sources should be used:
# - cidr_blocks / ipv6_cidr_blocks / prefix_list_ids
# - source_security_group_id
# - self = true
# -------------------------
variable "ingress_rules" {
  type = list(object({
    description              = string
    from_port                = number
    to_port                  = number
    protocol                 = string

    cidr_blocks              = optional(list(string))
    ipv6_cidr_blocks         = optional(list(string))
    prefix_list_ids          = optional(list(string))

    source_security_group_id = optional(string)
    self                     = optional(bool)
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ingress_rules : (
        # If self=true then no other source can be set
        (try(r.self, false) == true) ?
        (
          try(r.source_security_group_id, null) == null &&
          try(r.cidr_blocks, null) == null &&
          try(r.ipv6_cidr_blocks, null) == null &&
          try(r.prefix_list_ids, null) == null
        )
        :
        # If source SG is set then no cidr/prefix/self can be set
        (try(r.source_security_group_id, null) != null) ?
        (
          try(r.cidr_blocks, null) == null &&
          try(r.ipv6_cidr_blocks, null) == null &&
          try(r.prefix_list_ids, null) == null &&
          try(r.self, null) == null
        )
        :
        # Otherwise must set at least one of cidr/ipv6/prefix
        (
          try(r.cidr_blocks, null) != null ||
          try(r.ipv6_cidr_blocks, null) != null ||
          try(r.prefix_list_ids, null) != null
        )
      )
    ])
    error_message = "Invalid ingress rule: choose either (cidr/ipv6/prefix) OR source_security_group_id OR self=true (mutually exclusive)."
  }
}

# -------------------------
# Egress Rules
# -------------------------
variable "egress_rules" {
  type = list(object({
    description                 = string
    from_port                   = number
    to_port                     = number
    protocol                    = string

    cidr_blocks                 = optional(list(string))
    ipv6_cidr_blocks            = optional(list(string))
    prefix_list_ids             = optional(list(string))

    destination_security_group_id = optional(string)
  }))

  # Default: allow all outbound IPv4
  default = [
    {
      description  = "Allow all outbound"
      from_port    = 0
      to_port      = 0
      protocol     = "-1"
      cidr_blocks  = ["0.0.0.0/0"]
    }
  ]

  validation {
    condition = alltrue([
      for r in var.egress_rules : (
        # If destination SG is set then no cidr/prefix can be set
        (try(r.destination_security_group_id, null) != null) ?
        (
          try(r.cidr_blocks, null) == null &&
          try(r.ipv6_cidr_blocks, null) == null &&
          try(r.prefix_list_ids, null) == null
        )
        :
        # Otherwise must set at least one of cidr/ipv6/prefix
        (
          try(r.cidr_blocks, null) != null ||
          try(r.ipv6_cidr_blocks, null) != null ||
          try(r.prefix_list_ids, null) != null
        )
      )
    ])
    error_message = "Invalid egress rule: choose either (cidr/ipv6/prefix) OR destination_security_group_id."
  }
}