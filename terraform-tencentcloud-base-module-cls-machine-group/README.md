<!-- BEGIN_TF_DOCS -->
# terraform-tencentcloud-base-module-cls-machine-group

This module is used to create foundational **CLS Machine Group** resources on Tencent Cloud, for example:
- Feature 1: Create a machine group for log collection configuration with IP-based or label-based grouping
- Feature 2: Support multi-environment reuse (dev/stage/prod) with automatic naming and tagging for environment-level resource isolation and unified management
- Feature 3: Flexible machine identification using IP addresses or labels for dynamic log collection scenarios
- Feature 4: Support tags for the machine group to improve cost allocation and resource discovery

## Features

- Feature A: Reuse one codebase across multiple environments (dev/stage/prod); generate machine group names automatically using prefix/suffix rules
- Feature B: Control machine grouping method with variables:
    - IP-based grouping for static environments
    - Label-based grouping for dynamic environments with auto-scaling
- Feature C: Fully compatible with terraform-docs; all variables and outputs include English descriptions for automated documentation generation
- Feature D: Standardized tagging (tags) for machine groups (env/app/project, etc.) to make it easier to filter and report in the Tencent Cloud console and billing views

# Usage

```hcl
module "create_cls_machine_group" {
  source = "path/to/this/module"  # Module source (local path or Terraform Registry address)

  group_name         = "test-machine-group"     # (Required) CLS machine group name.
  machine_group_type = {
    type   = "ip"                                 # (Required) Machine group type: "ip" or "label".
    values = ["192.168.1.1", "192.168.1.2"]       # Provide at least one identifier.
  }

  tags = {                         # (Required) Resource tags (up to 40 unique key/value pairs).
    "us-mik:account-name" = "finance-team-member"  # Tag key/value for account ownership / cost attribution.
    "us-mik:cost-centre"  = "546.000.626.00"       # Tag key/value for cost center allocation.
  }
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
| [tencentcloud_cls_machine_group.this](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/cls_machine_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_group_name"></a> [group\_name](#input\_group\_name) | (Required) The name of the machine group.<br>Must be a non-empty string with the following constraints:<br>- Length must be between 1 and 255 characters (exclusive)<br>- Allowed characters: a-z, A-Z, 0-9, underscore (\_), and dash (-)<br>Example:<br> group\_name = "cloud\_us-mik\_cls\_machine\_group\_prod" | `string` | n/a | yes |
| <a name="input_machine_group_type"></a> [machine\_group\_type](#input\_machine\_group\_type) | (Required) Structure describing how CLS discovers machines.<br><br>machine\_group\_type = {<br>&nbsp;&nbsp;type&nbsp;&nbsp;=&nbsp;"ip"<br>&nbsp;&nbsp;values = ["192.168.1.1", "192.168.1.2"]<br>}<br><br>- type: "ip" for IP-based groups, "label" for label-based groups.<br>- values: Non-empty list of identifiers (IPs or label expressions) matching the chosen type. | `object({ type = string, values = list(string) })` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Required) Key-value pairs for categorizing and organizing resources.<br><br>Requirements:<br>- Must be a map of string key-value pairs.<br>- Useful for resource management, cost allocation, and access control.<br>- Must include mandatory tags: us-mik:account-name and us-mik:cost-centre.<br><br>Example: {<br>  us-mik:account-name = "finance-team-member"<br>  us-mik:cost-centre = "546.000.626.00"<br>} | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_group_name"></a> [group\_name](#output\_group\_name) | The name of the created machine group |
| <a name="output_machine_group_id"></a> [machine\_group\_id](#output\_machine\_group\_id) | The ID of the created machine group |
| <a name="output_machine_group_type"></a> [machine\_group\_type](#output\_machine\_group\_type) | Type of the machine group (ip or label) |
| <a name="output_tags"></a> [tags](#output\_tags) | Tags associated with the machine group |
<!-- END_TF_DOCS -->

