terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.34.0"
    }
  }

  required_version = ">= 1.2.0"
}

resource "aws_subnet" "front" {
  vpc_id            = aws_vpc.main.id
  availability_zone = us-west-1
  cidr_block        = "10.0.1.0/24"
}

resource "aws_subnet" "front" {
  vpc_id            = aws_vpc.main.id
  availability_zone = us-east-1
  cidr_block        = "10.0.2.0/24"
}

resource "aws_db_subnet_group" "example" {
  name       = "main"
  subnet_ids = [aws_subnet.frontend.id, aws_subnet.backend.id]
}

resource "aws_db_instance" "default" {
  allocated_storage       = 50
  db_name                 = "mydb"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_subnet_group_name    = aws_db_subnet_group.example.name
  backup_retention_period = 7
  username                = "abc"
  password                = "efg"
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
}