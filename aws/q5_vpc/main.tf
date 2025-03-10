terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.34.0"
    }
  }

  required_version = ">= 1.2.0"
}

resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "example_public" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = var.vpc_subnet_public_cidr
  availability_zone = "us-east-1c"
}

resource "aws_subnet" "example_private" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = var.vpc_subnet_private_cidr
  availability_zone = "us-east-1c"
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_nat_gateway" "example" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.example_private.id
}

resource "aws_route_table" "example_private" {
  vpc_id = aws_vpc.example.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }
}

resource "aws_route_table" "example_public" {
  vpc_id = aws_vpc.example.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }
}

resource "aws_route_table_association" "example_public" {
  subnet_id      = aws_subnet.example_public.id
  route_table_id = aws_route_table.example_public.id
}

resource "aws_route_table_association" "example_private" {
  subnet_id      = aws_subnet.example_private.id
  route_table_id = aws_route_table.example_private.id
}