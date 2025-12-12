# Setup run to create test logset and topic for config testing
run "setup" {
  command = apply

  module {
    source = "./tests/setup"
  }

  variables {
    logset_name = "test-logset"
    topic_name  = "test-topic"
    tags = {
      "us-mik:account-name" = "finance-team-member"
      "us-mik:cost-centre"  = "546.000.626.00"
    }
  }
}

run "config_creation_test" {
  command = apply

  variables {
    name     = "test-config-2"
    path     = "/var/log/app.log"
    log_type = "json_log"

    # Individual config configuration parameters (kept minimal for provider schema)
    user_define_rule = null
  }

  assert {
    condition     = output.name == var.name
    error_message = <<-EOT
      The output name value does not match the input variable.
      Output value: ${output.name}
      Expected value: ${var.name}
    EOT
  }

  assert {
    condition     = output.path == var.path
    error_message = <<-EOT
      The output path value does not match the input variable.
      Output value: ${output.path}
      Expected value: ${var.path}
    EOT
  }

  assert {
    condition     = output.log_type == var.log_type
    error_message = <<-EOT
      The output log_type value does not match the input variable.
      Output value: ${output.log_type}
      Expected value: ${var.log_type}
    EOT
  }
}

