# Setup module to query existing VPC, Subnet, and Security Groups using data sources
data "tencentcloud_vpc" "this" {
  id = var.vpc_name
}

data "tencentcloud_subnet" "this" {
  subnet_id = var.subnet_name
  vpc_id    = data.tencentcloud_vpc.this.id
}

# Query security groups (name parameter may be optional in provider)
data "tencentcloud_security_groups" "this" {
  name = var.security_group_name
}

