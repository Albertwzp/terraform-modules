data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
}

resource "aws_vpc" "this" {
}

resource "aws_subnet" "this" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_vpc_block_public_access_exclusion" "this" {
  subnet_id                       = aws_subnet.this.id
  internet_gateway_exclusion_mode = "allow-egress"
}

resource "aws_security_group" "this" {
  name        = "sec_group_22"
  description = "Security group for EC2 instances"

  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  count                  = var.num
  ami                    = data.aws_ami.this.id
  instance_type          = var.ins_type
  subnet_id              = aws_subnet.this.id
  vpc_security_group_ids = [aws_security_group.this.id]
}