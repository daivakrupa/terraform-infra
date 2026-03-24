# -------------------------
# VPC Outputs
# -------------------------
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.main.arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# -------------------------
# Internet Gateway Outputs
# -------------------------
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "internet_gateway_arn" {
  description = "The ARN of the Internet Gateway"
  value       = aws_internet_gateway.main.arn
}

# -------------------------
# Public Subnet Outputs
# -------------------------
output "public_subnet_az1_id" {
  description = "The ID of the public subnet in AZ1"
  value       = aws_subnet.public_az1.id
}

output "public_subnet_az2_id" {
  description = "The ID of the public subnet in AZ2"
  value       = aws_subnet.public_az2.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.public_az1.id, aws_subnet.public_az2.id]
}

output "public_subnet_az1_arn" {
  description = "The ARN of the public subnet in AZ1"
  value       = aws_subnet.public_az1.arn
}

output "public_subnet_az2_arn" {
  description = "The ARN of the public subnet in AZ2"
  value       = aws_subnet.public_az2.arn
}

output "public_subnet_az1_cidr_block" {
  description = "The CIDR block of the public subnet in AZ1"
  value       = aws_subnet.public_az1.cidr_block
}

output "public_subnet_az2_cidr_block" {
  description = "The CIDR block of the public subnet in AZ2"
  value       = aws_subnet.public_az2.cidr_block
}

# -------------------------
# Private Subnet Outputs
# -------------------------
output "private_subnet_az1_id" {
  description = "The ID of the private subnet in AZ1"
  value       = aws_subnet.private_az1.id
}

output "private_subnet_az2_id" {
  description = "The ID of the private subnet in AZ2"
  value       = aws_subnet.private_az2.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [aws_subnet.private_az1.id, aws_subnet.private_az2.id]
}

output "private_subnet_az1_arn" {
  description = "The ARN of the private subnet in AZ1"
  value       = aws_subnet.private_az1.arn
}

output "private_subnet_az2_arn" {
  description = "The ARN of the private subnet in AZ2"
  value       = aws_subnet.private_az2.arn
}

output "private_subnet_az1_cidr_block" {
  description = "The CIDR block of the private subnet in AZ1"
  value       = aws_subnet.private_az1.cidr_block
}

output "private_subnet_az2_cidr_block" {
  description = "The CIDR block of the private subnet in AZ2"
  value       = aws_subnet.private_az2.cidr_block
}

# -------------------------
# NAT Gateway Outputs
# -------------------------
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = var.enable_nat_gateway ? aws_nat_gateway.main[0].id : null
}

output "nat_gateway_public_ip" {
  description = "The public IP of the NAT Gateway"
  value       = var.enable_nat_gateway ? aws_eip.nat[0].public_ip : null
}

output "nat_gateway_allocation_id" {
  description = "The allocation ID of the Elastic IP for NAT Gateway"
  value       = var.enable_nat_gateway ? aws_eip.nat[0].allocation_id : null
}

# -------------------------
# Route Table Outputs
# -------------------------
output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private.id
}

# -------------------------
# Availability Zone Outputs
# -------------------------
output "availability_zone_1" {
  description = "First availability zone"
  value       = var.availability_zone_1
}

output "availability_zone_2" {
  description = "Second availability zone"
  value       = var.availability_zone_2
}