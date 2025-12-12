<!-- BEGIN_TF_DOCS -->
# terraform-tencentcloud-base-module-cls-config-attachment

This module is used to create foundational **CLS Config Attachment** resources on Tencent Cloud, for example:
- Feature 1: Attach a log collection configuration to a machine group for log collection
- Feature 2: Support multi-environment reuse (dev/stage/prod) with automatic resource management
- Feature 3: Enable log collection from machines in a specific group using a predefined configuration
- Feature 4: Manage associations between configurations and machine groups efficiently

## Features

- Feature A: Reuse one codebase across multiple environments (dev/stage/prod); manage config attachments consistently
- Feature B: Simple attachment management with variables:
    - Associate configurations with machine groups
    - Enable log collection from multiple machines at once
- Feature C: Fully compatible with terraform-docs; all variables and outputs include English descriptions for automated documentation generation
- Feature D: Standardized resource management for config attachments to make it easier to track and manage log collection associations

# Usage

```hcl
module "create_cls_config_attachment" {
  source = "path/to/this/module"  # Module source (local path or Terraform Registry address)

  config_id        = run.setup.config_id        # (Required) The log collection configuration ID.
  group_id         = run.setup.machine_group_id # (Required) The machine group ID to attach.
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | ~> 1.82.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | 1.82.38 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tencentcloud_cls_config_attachment.this](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/cls_config_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config_id"></a> [config\_id](#input\_config\_id) | (Required) The ID of the log collection configuration to attach.<br>Must be a valid CLS config ID in UUID format (8-4-4-4-12 hexadecimal digits).<br>Example:<br>  config\_id = "93685536-22de-44ca-99aa-2800d36fbb6e" | `string` | n/a | yes |
| <a name="input_group_id"></a> [group\_id](#input\_group\_id) | (Required) Machine group ID to attach the log collection configuration to.<br><br>Associates the log collection configuration with a specific machine group,<br>enabling log collection from all machines in that group. The machine group<br>must exist before creating this attachment.<br><br>Usage Notes:<br>- Must be a valid machine group ID in UUID format<br>- Machine group must exist before creating the attachment<br>- One config can be attached to multiple machine groups<br>- Attachment enables log collection from machines in the group<br><br>Example:<br>  group\_id = "93685536-22de-44ca-99aa-2800d36fbb6e" | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_attachment_id"></a> [attachment\_id](#output\_attachment\_id) | The ID of the created config attachment |
| <a name="output_config_id"></a> [config\_id](#output\_config\_id) | The ID of the log collection configuration |
| <a name="output_group_id"></a> [group\_id](#output\_group\_id) | The ID of the machine group attached to the configuration |
<!-- END_TF_DOCS -->

