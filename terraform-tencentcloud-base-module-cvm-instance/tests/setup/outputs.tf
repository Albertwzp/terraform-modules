output "vpc_id" {
  description = "ID of the queried VPC"
  value       = data.tencentcloud_vpc.this.id
}

output "vpc_name" {
  description = "Name of the queried VPC"
  value       = data.tencentcloud_vpc.this.name
}

output "subnet_id" {
  description = "ID of the queried subnet"
  value       = data.tencentcloud_subnet.this.id
}

output "subnet_name" {
  description = "Name of the queried subnet"
  value       = data.tencentcloud_subnet.this.name
}

output "availability_zone" {
  description = "Availability zone of the queried subnet"
  value       = data.tencentcloud_subnet.this.availability_zone
}

output "security_group_ids" {
  description = "List of security group IDs"
  value       = var.security_group_name != null ? try(data.tencentcloud_security_groups.this.security_groups[*].security_group_id, []) : []
}

output "security_group_id" {
  description = "First security group ID (for convenience)"
  value       = var.security_group_name != null ? try(data.tencentcloud_security_groups.this.security_groups[0].security_group_id, null) : null
}

