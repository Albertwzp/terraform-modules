## ec2_instance module
This is a terraform module  create AWS EC2 instance
- The module should use the latest Amazon Linux 2 AMI.
- The instance type should be configurable (default to t2.micro).
- The module should create a new VPC with a single public subnet.
- The module should create a security group that allows SSH access (port 22) from anywhere.

## Useage
copy this module folder as a sub foleder named ec2-instance to your project & use it like below example

## example
```
module "ec2_instance" {
  source  = "./ec2-instance"
  num    = 1
  instance_type = "t2.micro"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| num | instances num | `number` | `1` | no |
| instance_type | instance type | `string` | `t2.micro` | no |