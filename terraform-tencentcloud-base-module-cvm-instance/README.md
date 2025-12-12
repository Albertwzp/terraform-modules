<!-- BEGIN_TF_DOCS -->
# terraform-tencentcloud-base-module-cls-topic

This module is used to create foundational **CLS Log Topic** resources on Tencent Cloud, for example:
- Feature 1: Create a log topic under a specified logset (Logset) and configure basics such as partitions, storage, and retention
- Feature 2: Support multi-environment reuse (dev/stage/prod) with automatic naming and tagging for environment-level log isolation and unified management
- Feature 3: Optionally enable Web Tracking / anonymous access extensions, suitable for writing logs directly from frontend/browser scenarios
- Feature 4: Support tags for the log topic to improve cost allocation and resource discovery

## Features

- Feature A: Reuse one codebase across multiple environments (dev/stage/prod); generate topic names automatically using prefix/suffix rules
- Feature B: Control optional capabilities with variables, for example:
    - Enable/disable automatic partition split (auto split)
    - Choose storage class (standard storage / infrequent access storage)
    - Configure retention days and hot/cold tiering strategy
- Feature C: Fully compatible with terraform-docs; all variables and outputs include English descriptions for automated documentation generation
- Feature D: Reserved extension fields (e.g., Web Tracking / anonymous access policy) to support future scenarios such as frontend instrumentation and browser log collection
- Feature E: Standardized tagging (tags) for topics (env/app/project, etc.) to make it easier to filter and report in the Tencent Cloud console and billing views

# Usage

```hcl
module "create_cls_topic" {
  source = "path/to/this/module"  # Module source (local path or Terraform Registry address)

  topic_name = "test-topic-2"     # (Required) CLS log topic name.
  logset_id  = run.setup.logset_id # (Required) The Logset ID that this topic belongs to.

  tags = {                         # (Optional) Resource tags (up to 10 unique key/value pairs).
    "us-mik:account-name" = "finance-team-member"  # Tag key/value for account ownership / cost attribution.
    "us-mik:cost-centre"  = "546.000.626.00"       # Tag key/value for cost center allocation.
  }

  auto_split           = false     # (Optional) Whether to enable automatic partition split.
  max_split_partitions = 20        # (Optional) Maximum number of partitions when auto split is enabled.
  partition_count      = 1         # (Optional) Initial number of partitions for the topic (upper limit depends on CLS constraints).
  period               = 30        # (Optional) Log retention period in days.
  storage_type         = "hot"     # (Optional) Storage class: "hot" for real-time/standard storage, "cold" for low-frequency/offline storage (may require allowlist).
  describes            = "Production Topic 1" # (Optional) Topic description.
  hot_period           = 10        # (Optional) Hot tier retention in days (only meaningful when storage_type is "hot"; must be >= 7 and < period; 0 disables tiering/sinking).
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
| [tencentcloud_cls_topic.this](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/cls_topic) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_split"></a> [auto\_split](#input\_auto\_split) | (Optional) Controls whether to enable automatic partition splitting. <br> <br>When enabled, the system automatically creates new partitions based on the<br>traffic volume and storage size of the topic. This helps maintain optimal<br>performance during traffic spikes without manual intervention. <br> <br>Usage Notes:<br>- When value is null, Tencent Cloud backend will automatically set the default value<br>- When specified, must be either true or false<br> <br>Usage Examples:<br>- auto\_split = true   # Enable automatic partition splitting<br>- auto\_split = false  # Disable automatic partition splitting<br>- auto\_split = null   # Use backend default value | `bool` | `null` | no |
| <a name="input_describes"></a> [describes](#input\_describes) | (Optional) Description for the log topic.<br><br>Provides human-readable documentation for the log topic, helping team members<br>understand the purpose, scope, and usage of the topic. This description<br>appears in the CLS console and should clearly explain the topic's function.<br><br>Usage Notes:<br>- When value is null, Tencent Cloud backend will automatically set the default value<br>- Use descriptive text to explain the topic's purpose and content<br>- Include information about the applications or services that write to this topic<br>- Maximum length is 500 characters when specified<br><br>Examples:<br># Basic description for application logs<br>describes = "Application logs for user-service including API requests and errors" | `string` | `null` | no |
| <a name="input_hot_period"></a> [hot\_period](#input\_hot\_period) | (Optional) Hot storage period in days for log sinking/cold-hot tiering.<br><br>Controls the log sinking feature which manages the transition of logs from hot <br>storage to subsequent storage tiers (typically lower-cost storage stages).<br><br>Value Options:<br>- 0: Disable log sinking/cold-hot tiering (logs will not be tiered)<br>- Non-zero: Enable log sinking/cold-hot tiering. Logs will remain in standard <br>  (hot) storage for hot\_period days before transitioning to subsequent storage <br>  tiers according to the sinking strategy<br>- null: Tencent Cloud backend will automatically set the default value<br><br>Constraints:<br>- When non-zero, hot\_period must be >= 7 days<br>- When non-zero, hot\_period must be less than period (total retention period)<br>- Only effective when storage\_type = "hot" (ignored when storage\_type = "cold")<br><br>Usage Examples:<br># Enable log sinking: logs stay in hot storage for 10 days, then transition<br># Total retention period is 30 days<br>storage\_type = "hot"<br>period       = 30<br>hot\_period   = 10<br><br># Disable log sinking (no tiering)<br>hot\_period = 0<br><br># Invalid: hot\_period must be less than period<br># period = 30, hot\_period = 30  # This is invalid<br><br># When storage\_type = "cold", hot\_period is ignored<br>storage\_type = "cold"<br>hot\_period   = 10  # This value will be ignored | `number` | `null` | no |
| <a name="input_logset_id"></a> [logset\_id](#input\_logset\_id) | (Required) The ID of the logset to which this topic belongs.<br>Must be a valid CLS logset ID in UUID format (8-4-4-4-12 hexadecimal digits).<br>Example:<br>  logset\_id = "93685536-22de-44ca-99aa-2800d36fbb6e" | `string` | n/a | yes |
| <a name="input_max_split_partitions"></a> [max\_split\_partitions](#input\_max\_split\_partitions) | (Optional) Maximum number of partitions to split into for this topic if automatic split is enabled.<br><br>Defines the upper limit for automatic partition creation when auto-split is enabled.<br>The system will not create more partitions than this value regardless of traffic volume.<br><br>Usage Notes:<br>- When value is null, Tencent Cloud backend will automatically set the default value<br>- Only applicable when auto\_split is set to true<br>- Provides a safety limit to prevent excessive partition creation<br>- Should be set based on expected scale and performance requirements<br>- Must be a positive integer between 1 and 50 when specified<br><br>Examples:<br># Allow up to 50 partitions<br> max\_split\_partitions = 50 | `number` | `null` | no |
| <a name="input_partition_count"></a> [partition\_count](#input\_partition\_count) | (Optional) Number of log topic partitions.<br><br>Specifies the initial number of partitions for the log topic. Each partition<br>can handle a certain throughput, and more partitions allow for higher<br>concurrent read/write operations.<br><br>Usage Notes:<br>- When value is null, Tencent Cloud backend will automatically set the default value<br>- Determines the initial partitioning scheme for the topic<br>- More partitions allow for better parallelism but increase management overhead<br>- Choose based on expected write volume and consumer parallelism needs<br>- Must be a positive integer between 1 and 10 when specified<br><br>Examples:<br> partition\_count = 1 | `number` | `null` | no |
| <a name="input_period"></a> [period](#input\_period) | (Optional) Log retention period in days.<br><br>Controls how long log data is retained in storage before being automatically<br>deleted. Different retention periods may apply to different storage types.<br><br>Usage Notes:<br>- When value is null, Tencent Cloud backend will automatically set the default value (defaults to 30 days)<br>- Standard storage: 1 to 3600 days<br>- Infrequent storage: 7 to 3600 days<br>- **Special value 3640: Enables permanent retention**<br><br>Important:<br>- Value 3640 specifically indicates that logs will be retained permanently<br>- This is a special marker value, not an actual 3640-day period<br>- For permanent retention, use exactly 3640, not any other value<br>- Must be a positive integer between 1 and 3640 when specified<br><br>Examples:<br> # Standard retention for production<br> period = 30 | `number` | `null` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | (Optional) Storage type for the log topic.<br><br>Determines the storage tier for log data, affecting performance characteristics<br>and cost considerations. Choose based on access patterns and budget requirements.<br><br>Storage Types:<br>- "hot": High-performance storage for frequently accessed logs<br>  - Lower latency for search and analysis operations<br>  - Higher storage cost but better performance<br>  - Ideal for active debugging, monitoring, and real-time analysis<br><br>- "cold": Cost-effective storage for infrequently accessed logs<br>  - Higher latency for search operations<br>  - Lower storage cost with adequate durability<br>  - Suitable for compliance, archival, and historical analysis<br><br>Usage Notes:<br>- When value is null, Tencent Cloud backend will automatically set the default value<br>- Hot storage provides better query performance for active logs<br>- Cold storage offers cost savings for long-term retention<br>- Consider access frequency when choosing storage type<br>- Must be either "hot" or "cold" when specified<br><br>Examples:<br># Hot storage for production monitoring logs<br>storage\_type = "hot"<br><br># Cold storage for archived compliance logs<br>storage\_type = "cold" | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Required) Key-value pairs for categorizing and organizing resources.<br><br>Requirements:<br>- Must be a map of string key-value pairs.<br>- Useful for resource management, cost allocation, and access control.<br>- Must include mandatory tags: us-mik:account-name and us-mik:cost-centre.<br><br>Example: {<br>  us-mik:account-name = "finance-team-member"<br>  us-mik:cost-centre = "546.000.626.00"<br>} | `map(string)` | n/a | yes |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | (Required) The name of the log topic.<br>Must be a non-empty string with the following constraints:<br>- Length must be between 1 and 255 characters (exclusive)<br>- Allowed characters: a-z, A-Z, 0-9, underscore (\_), and dash (-)<br>Example:<br> topic\_name = "cloud\_us-mik\_cls\_log\_prod" | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_auto_split"></a> [auto\_split](#output\_auto\_split) | Whether automatic partition splitting is enabled |
| <a name="output_describes"></a> [describes](#output\_describes) | Description for the log topic |
| <a name="output_hot_period"></a> [hot\_period](#output\_hot\_period) | Hot storage period in days for log sinking/cold-hot tiering |
| <a name="output_logset_id"></a> [logset\_id](#output\_logset\_id) | The ID of the logset to which this topic belongs |
| <a name="output_max_split_partitions"></a> [max\_split\_partitions](#output\_max\_split\_partitions) | Maximum number of partitions to split into |
| <a name="output_partition_count"></a> [partition\_count](#output\_partition\_count) | Number of log topic partitions |
| <a name="output_period"></a> [period](#output\_period) | Log retention period in days |
| <a name="output_storage_type"></a> [storage\_type](#output\_storage\_type) | Storage type for the log topic (hot or cold) |
| <a name="output_tags"></a> [tags](#output\_tags) | Tags associated with the log topic |
| <a name="output_topic_id"></a> [topic\_id](#output\_topic\_id) | The ID of the created log topic |
| <a name="output_topic_name"></a> [topic\_name](#output\_topic\_name) | The name of the created log topic |
<!-- END_TF_DOCS -->