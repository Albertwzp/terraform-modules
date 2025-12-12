# Setup run to query existing VPC, Subnet, and Security Groups using data sources
run "setup" {
  command = plan # Use plan since we're only querying data sources

  module {
    source = "./tests/setup"
  }

  variables {
    vpc_name            = "vpc-fs51mapb"    # Name of existing VPC to query
    subnet_name         = "subnet-76tazp06" # Name of existing subnet to query
    security_group_name = "sg-kff383l3"     # Name of existing security group to query (optional)
    availability_zone   = "ap-guangzhou-4"  # Availability zone for subnet query
  }

  assert {
    condition = (
      output.vpc_id != null
      && trimspace(output.vpc_id) != ""
    )
    error_message = "vpc_id is empty. Please ensure the VPC with name '${var.vpc_name}' exists in your account."
  }

  assert {
    condition = (
      output.subnet_id != null
      && trimspace(output.subnet_id) != ""
    )
    error_message = "subnet_id is empty. Please ensure a subnet exists in the VPC with name '${var.vpc_name}'."
  }
}

# Test 1: Basic CVM instance creation
run "test_basic_instance_creation" {
  command = apply

  variables {
    availability_zone = run.setup.availability_zone
    vpc_id            = run.setup.vpc_id
    subnet_id         = run.setup.subnet_id

    # Required: Image and instance type
    image_id      = "img-eb30mz89" # Example image ID - adjust based on your region/AZ
    instance_type = "S5.MEDIUM2"   # Example instance type

    # Optional: Instance naming
    instance_name = "test-cvm-basic"
    hostname      = "test-cvm-basic"

    # Optional: System disk
    system_disk_type = "CLOUD_PREMIUM"
    system_disk_size = 50

    # Optional: Public IP
    allocate_public_ip         = false
    internet_max_bandwidth_out = null
    user_data = base64encode("mkdir -p /tmp/loglistener/ && (wget -O /tmp/loglistener/install.sh http://mirrors.tencentyun.com/install/cls/install.sh || wget -O /tmp/loglistener/install.sh https://mirrors.tencent.com/install/cls/install.sh) && chmod +x /tmp/loglistener/install.sh && /tmp/loglistener/install.sh -s ${var.SECRET_ID} -k ${var.SECRET_KEY} ap-guangzhou -n intra -e true -u false -l testcvm")

    # Required: Tags
    tags = {
      "us-mik:account-name" = "finance-team-member"
      "us-mik:cost-centre"  = "546.000.626.00"
    }
  }

  assert {
    condition     = output.instance_id != null && output.instance_id != ""
    error_message = "instance_id must be set and non-empty."
  }

  assert {
    condition     = output.instance_name == var.instance_name
    error_message = <<-EOT
      The output instance_name value does not match the input variable.
      Output value: ${output.instance_name}
      Expected value: ${var.instance_name}
    EOT
  }

  assert {
    condition     = output.vpc_id == var.vpc_id
    error_message = <<-EOT
      The output vpc_id value does not match the input variable.
      Output value: ${output.vpc_id}
      Expected value: ${var.vpc_id}
    EOT
  }

  assert {
    condition     = output.subnet_id == var.subnet_id
    error_message = <<-EOT
      The output subnet_id value does not match the input variable.
      Output value: ${output.subnet_id}
      Expected value: ${var.subnet_id}
    EOT
  }

  assert {
    condition     = output.availability_zone == var.availability_zone
    error_message = <<-EOT
      The output availability_zone value does not match the input variable.
      Output value: ${output.availability_zone}
      Expected value: ${var.availability_zone}
    EOT
  }

  assert {
    condition     = contains(["RUNNING", "STOPPED", "STARTING", "STOPPING"], output.instance_status)
    error_message = <<-EOT
      The output instance_status must be a valid CVM instance status.
      Output value: ${output.instance_status}
    EOT
  }

  assert {
    condition     = output.cpu != null && output.cpu > 0
    error_message = "cpu must be a positive number."
  }

  assert {
    condition     = output.memory != null && output.memory > 0
    error_message = "memory must be a positive number."
  }

  assert {
    condition     = output.private_ip != null && output.private_ip != ""
    error_message = "private_ip must be set and non-empty."
  }
}
