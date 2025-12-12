<!-- BEGIN_TF_DOCS -->
# terraform-tencentcloud-base-module-cls-config

This module is used to create foundational **CLS Log Collection Configuration** resources on Tencent Cloud, for example:
- Feature 1: Create a log collection configuration to collect logs from specified paths on machines
- Feature 2: Support multi-environment reuse (dev/stage/prod) with automatic naming and tagging for environment-level resource isolation and unified management
- Feature 3: Flexible log parsing with multiple log types (JSON, delimiter, regex, etc.) for different log formats
- Feature 4: Support tags for the configuration to improve cost allocation and resource discovery

## Features

- Feature A: Reuse one codebase across multiple environments (dev/stage/prod); generate configuration names automatically using prefix/suffix rules
- Feature B: Control log collection and parsing with variables:
    - Multiple log types (json_log, delimiter_log, fullregex_log, etc.)
    - Custom extraction rules for complex log formats
    - Path exclusion for filtering unwanted logs
- Feature C: Fully compatible with terraform-docs; all variables and outputs include English descriptions for automated documentation generation
- Feature D: Standardized tagging (tags) for configurations (env/app/project, etc.) to make it easier to filter and report in the Tencent Cloud console and billing views

# Usage

```hcl
module "create_cls_config" {
  source = "path/to/this/module"  # Module source (local path or Terraform Registry address)

  name      = "test-config"     # (Required) CLS log collection configuration name.
  path      = "/var/log/app.log"   # (Required) Log file path to collect.
  log_type  = "json_log"           # (Required) Log type: "json_log", "delimiter_log", "fullregex_log", etc.

  # Optional configuration parameters (only those still supported on the resource)
  output           = null           # (Optional) Output format configuration.
  user_define_rule = null           # (Optional) User-defined parsing rule in JSON format.
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
| [tencentcloud_cls_config.this](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/cls_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_log_type"></a> [log\_type](#input\_log\_type) | (Required) Log type. Determines how logs are parsed and structured.<br><br>Common log types:<br>- "json\_log": JSON format logs<br>- "delimiter\_log": Delimiter-separated logs (CSV, TSV, etc.)<br>- "fullregex\_log": Full regex parsing<br>- "minimalist\_log": Minimalist log format<br>- "multiline\_log": Multi-line log format<br><br>Usage Notes:<br>- Choose based on your log format<br>- Different log types require different extract\_rule configurations<br>- Must match the actual format of your log files<br><br>Examples:<br># JSON log format<br>log\_type = "json\_log"<br><br># Delimiter-separated log format<br>log\_type = "delimiter\_log" | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the log collection configuration.<br>Must be a non-empty string with the following constraints:<br>- Length must be between 1 and 255 characters (exclusive)<br>- Allowed characters: a-z, A-Z, 0-9, underscore (\_), and dash (-)<br>Example:<br> name = "cloud\_us-mik\_cls\_config\_prod" | `string` | n/a | yes |
| <a name="input_path"></a> [path](#input\_path) | (Required) Log file path. Supports wildcards (*) and regular expressions.<br><br>Examples:<br>- Single file: "/var/log/app.log"<br>- Multiple files: "/var/log/*.log"<br>- Directory: "/var/log/app/"<br>- Pattern: "/var/log/app/*.log"<br><br>Usage Notes:<br>- Must be a valid file system path<br>- Supports wildcard patterns for multiple file collection<br>- Path must exist on the target machine | `string` | n/a | yes |
| <a name="input_output"></a> [output](#input\_output) | (Optional) Output format configuration for collected logs. Mirrors the `output` argument on the `tencentcloud_cls_config` resource; when `null`, the provider uses its default behavior. | `string` | `null` | no |
| <a name="input_output"></a> [output](#input\_output) | (Optional) Output format configuration for collected logs. Mirrors the `output` argument on the `tencentcloud_cls_config` resource; when `null`, the provider uses its default behavior. | `string` | `null` | no |
| <a name="input_user_define_rule"></a> [user\_define\_rule](#input\_user\_define\_rule) | (Optional) User-defined parsing rule in JSON format.<br><br>Allows advanced users to define custom log parsing rules using JSON.<br>This provides maximum flexibility for complex log formats that don't<br>fit standard log types.<br><br>Usage Notes:<br>- When value is null, standard extraction rules are used<br>- Must be valid JSON format<br>- Overrides default extraction behavior<br>- Use when standard log types are insufficient<br><br>Examples:<br># Custom JSON parsing rule<br>user\_define\_rule = jsonencode({<br>  parse\_type = "regex"<br>  regex = "^(?P<time>\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}) (?P<level>\\w+) (?P<message>.*)$"<br>}) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config_id"></a> [config\_id](#output\_config\_id) | The ID of the created log collection configuration |
| <a name="output_log_type"></a> [log\_type](#output\_log\_type) | Log type configured for parsing |
| <a name="output_output"></a> [output](#output\_output) | Output format configured for the log collection (if set) |
| <a name="output_name"></a> [name](#output\_name) | The name of the created log collection configuration |
| <a name="output_path"></a> [path](#output\_path) | Log file path configured for collection |
<!-- END_TF_DOCS -->

