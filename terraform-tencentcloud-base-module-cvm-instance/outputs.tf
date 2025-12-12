output "instance_id" {
  description = "ID of the created CVM instance."
  value       = tencentcloud_instance.this.id
}

output "instance_name" {
  description = "Name of the CVM instance."
  value       = tencentcloud_instance.this.instance_name
}

output "availability_zone" {
  description = "Availability zone where the instance is running."
  value       = tencentcloud_instance.this.availability_zone
}

output "private_ip" {
  description = "Primary private IPv4 address of the instance."
  value       = tencentcloud_instance.this.private_ip
}

output "public_ip" {
  description = "Public IPv4 address of the instance (if allocated)."
  value       = tencentcloud_instance.this.public_ip
}

output "vpc_id" {
  description = "VPC ID where the instance resides."
  value       = tencentcloud_instance.this.vpc_id
}

output "subnet_id" {
  description = "Subnet ID where the instance resides."
  value       = tencentcloud_instance.this.subnet_id
}

output "tags" {
  description = "Effective tags on the instance."
  value       = tencentcloud_instance.this.tags
}

output "cpu" {
  description = "Number of vCPUs for the instance."
  value       = tencentcloud_instance.this.cpu
}

output "memory" {
  description = "Memory size of the instance in GB."
  value       = tencentcloud_instance.this.memory
}

output "os_name" {
  description = "Human-readable OS name of the instance."
  value       = tencentcloud_instance.this.os_name
}

output "create_time" {
  description = "Create time of the instance."
  value       = tencentcloud_instance.this.create_time
}

output "expired_time" {
  description = "Expiration time for PREPAID instances."
  value       = tencentcloud_instance.this.expired_time
}

output "instance_status" {
  description = "Current status of the instance (e.g., RUNNING, STOPPED)."
  value       = tencentcloud_instance.this.instance_status
}
