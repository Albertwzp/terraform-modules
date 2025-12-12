# Setup run to create test logset for machine group testing
run "setup" {
  command = apply

  module {
    source = "./tests/setup"
  }

  variables {
    logset_name = "test-logset"
    tags = {
      "us-mik:account-name" = "finance-team-member"
      "us-mik:cost-centre"  = "546.000.626.00"
    }
  }
}

run "machine_group_creation_test" {
  command = apply

  variables {
    group_name = "test-machine-group-2"
    machine_group_type = {
      type   = "ip"
      values = ["192.168.1.1", "192.168.1.2"]
    }
    tags = {
      "us-mik:account-name" = "finance-team-member"
      "us-mik:cost-centre"  = "546.000.626.00"
    }
  }

  assert {
    condition     = output.group_name == var.group_name
    error_message = <<-EOT
      The output group_name value does not match the input variable.
      Output value: ${output.group_name}
      Expected value: ${var.group_name}
    EOT
  }

  assert {
    condition     = output.machine_group_type == var.machine_group_type.type
    error_message = <<-EOT
      The output machine_group_type value does not match the input variable.
      Output value: ${output.machine_group_type}
      Expected value: ${var.machine_group_type.type}
    EOT
  }

}

