variable "vpc_cidr" {
  description = "CIDR block for the subnet"
  default     = "10.0.0.0/16"
}

variable "vpc_subnet_public_cidr" {
  default = "10.0.0.0/24"
}

variable "vpc_subnet_private_cidr" {
  default = "10.0.1.0/24"
}