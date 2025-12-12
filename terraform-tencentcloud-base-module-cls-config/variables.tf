variable "name" {
  description = <<-EOT
    (Required) The name of the log collection configuration.
    Must be a non-empty string with the following constraints:
    - Length must be between 1 and 255 characters (exclusive)
    - Allowed characters: a-z, A-Z, 0-9, underscore (_), and dash (-)
    Example:
     name = "cloud_us-mik_cls_config_prod"
    EOT
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name)) && length(var.name) > 0 && length(var.name) < 255
    error_message = "The length of the name should be between 1 and 255 characters, and the allowed characters are a-z, A-Z, 0-9, _, and -."
  }
}

// logset_id/topic_id are no longer arguments on tencentcloud_cls_config in
// the provider version used here; they are managed via separate attachment
// resources. Accordingly, this module no longer accepts those inputs.

variable "path" {
  description = <<-EOT
    (Required) Log file path. Supports wildcards (*) and regular expressions.
    
    Examples:
    - Single file: "/var/log/app.log"
    - Multiple files: "/var/log/*.log"
    - Directory: "/var/log/app/"
    - Pattern: "/var/log/app/*.log"
    
    Usage Notes:
    - Must be a valid file system path
    - Supports wildcard patterns for multiple file collection
    - Path must exist on the target machine
  EOT
  type        = string
  validation {
    condition     = length(var.path) > 0 && length(var.path) <= 512
    error_message = "path must be a non-empty string with maximum length of 512 characters."
  }
}

variable "log_type" {
  description = <<-EOT
    (Required) Log type. Determines how logs are parsed and structured.
    
    Common log types:
    - "json_log": JSON format logs
    - "delimiter_log": Delimiter-separated logs (CSV, TSV, etc.)
    - "fullregex_log": Full regex parsing
    - "minimalist_log": Minimalist log format
    - "multiline_log": Multi-line log format
    
    Usage Notes:
    - Choose based on your log format
    - Different log types require different extract_rule configurations
    - Must match the actual format of your log files
    
    Examples:
    # JSON log format
    log_type = "json_log"
    
    # Delimiter-separated log format
    log_type = "delimiter_log"
  EOT
  type        = string
  validation {
    condition     = contains(["json_log", "delimiter_log", "fullregex_log", "minimalist_log", "multiline_log"], var.log_type)
    error_message = "log_type must be one of: json_log, delimiter_log, fullregex_log, minimalist_log, multiline_log."
  }
}

// extract_rule / exclude_paths are now nested blocks on the resource rather
// than top-level arguments and are not parameterised by this module for now.

variable "output" {
  description = <<-EOT
    (Optional) Output format configuration for collected logs.

    This argument mirrors the `output` field of the `tencentcloud_cls_config`
    resource in the Tencent Cloud provider. When set to null, the provider
    will use its own default behavior.
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "user_define_rule" {
  description = <<-EOT
    (Optional) User-defined parsing rule in JSON format.
    
    Allows advanced users to define custom log parsing rules using JSON.
    This provides maximum flexibility for complex log formats that don't
    fit standard log types.
    
    Usage Notes:
    - When value is null, standard extraction rules are used
    - Must be valid JSON format
    - Overrides default extraction behavior
    - Use when standard log types are insufficient
    
    Examples:
    # Custom JSON parsing rule
    user_define_rule = jsonencode({
      parse_type = "regex"
      regex = "^(?P<time>\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}) (?P<level>\\w+) (?P<message>.*)$"
    })
  EOT
  type        = string
  default     = null
  nullable    = true
}

// tencentcloud_cls_config no longer supports tags directly; tagging should be
// applied on logset/topic/machine-group resources instead, so this module
// no longer accepts a tags map.

