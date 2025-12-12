# Setup run to create test logset, topic, config, and machine group for attachment testing
run "setup" {
  command = apply

  module {
    source = "./tests/setup"
  }

  variables {
    logset_name        = "test-logset"
    topic_name         = "test-topic"
    config_name        = "test-config"
    machine_group_name = "test-machine-group"
    tags = {
      "us-mik:account-name" = "finance-team-member"
      "us-mik:cost-centre"  = "546.000.626.00"
    }
  }
}

run "config_attachment_creation_test" {
  command = apply

  variables {
    config_id = run.setup.config_id
    group_id  = run.setup.machine_group_id
  }

  assert {
    condition     = output.config_id == var.config_id
    error_message = <<-EOT
      The output config_id value does not match the input variable.
      Output value: ${output.config_id}
      Expected value: ${var.config_id}
    EOT
  }

  assert {
    condition     = output.group_id == var.group_id
    error_message = <<-EOT
      The output group_id value does not match the input variable.
      Output value: ${output.group_id}
      Expected value: ${var.group_id}
    EOT
  }
}

