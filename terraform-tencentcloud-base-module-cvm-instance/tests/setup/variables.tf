variable "vpc_name" {
  description = <<-EOT
    (Required) Name of the existing VPC to query.
    Example: "test-vpc"
  EOT
  type        = string
}

variable "subnet_name" {
  description = <<-EOT
    (Required) Name of the existing subnet to query.
    Example: "test-subnet"
  EOT
  type        = string
}

variable "security_group_name" {
  description = <<-EOT
    (Optional) Name of the existing security group to query.
    Example: "default"
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "availability_zone" {
  description = <<-EOT
    (Required) Availability zone for the subnet.
    Example: "ap-guangzhou-4"
  EOT
  type        = string
}

