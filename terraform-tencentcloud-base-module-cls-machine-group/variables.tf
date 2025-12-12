variable "group_name" {
  description = <<-EOT
    (Required) The name of the machine group.
    Must be a non-empty string with the following constraints:
    - Length must be between 1 and 255 characters (exclusive)
    - Allowed characters: a-z, A-Z, 0-9, underscore (_), and dash (-)
    Example:
     group_name = "cloud_us-mik_cls_machine_group_prod"
    EOT
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.group_name)) && length(var.group_name) > 0 && length(var.group_name) < 255
    error_message = "The length of the group name should be between 1 and 255 characters, and the allowed characters are a-z, A-Z, 0-9, _, and -."
  }
}

variable "machine_group_type" {
  description = <<-EOT
    (Required) Configuration block describing how the CLS machine group discovers members.

    Terraform must receive the exact structure that the Tencent Cloud provider expects:

      machine_group_type = {
        type   = "ip"    # or "label"
        values = ["192.168.1.1", "192.168.1.2"]
      }

    - type:
        - "ip"    : IP-based machine group. Machines are matched via explicit IPs.
        - "label" : Label-based machine group. Machines are matched via label expressions.
    - values:
        - For "ip", provide the list of IP addresses.
        - For "label", provide the list of label expressions.
        - Must contain at least one value and every element must be a non-empty string.
  EOT
  type = object({
    type   = string
    values = list(string)
  })

  validation {
    condition     = contains(["ip", "label"], var.machine_group_type.type)
    error_message = "machine_group_type.type must be either 'ip' or 'label'. Current value: ${var.machine_group_type.type}"
  }

  validation {
    condition     = length(var.machine_group_type.values) > 0
    error_message = "machine_group_type.values must contain at least one entry."
  }

  validation {
    condition     = alltrue([for v in var.machine_group_type.values : length(trimspace(v)) > 0])
    error_message = "machine_group_type.values entries must be non-empty strings."
  }
}

variable "tags" {
  description = <<-EOT
    (Required) Key-value pairs for categorizing and organizing resources.

    Requirements:
    - Must be a map of string key-value pairs.
    - Useful for resource management, cost allocation, and access control.
    - Must include mandatory tags: us-mik:account-name and us-mik:cost-centre.

    Example: {
      us-mik:account-name = "finance-team-member"
      us-mik:cost-centre = "546.000.626.00"
    }
    EOT
  type        = map(string)

  # key length: 127 max
  validation {
    condition     = alltrue([for k in keys(var.tags) : length(k) <= 127])
    error_message = "Tag *keys* are restricted to a maximum of 127 characters."
  }

  # check value length. 255 max
  validation {
    condition     = alltrue([for v in values(var.tags) : length(v) <= 255])
    error_message = "Tag *values* are restricted to a maximum of 255 characters."
  }

  validation {
    condition = alltrue([
      for key in keys(var.tags) : can(regex("^[a-z0-9:-]+$|^Name$", key))
    ])
    error_message = "Tag *keys* allow only the following characters: lowercase letters, 0 to 9, colon, and dash: [a-z0-9:-], Or Name with an uppercase 'N'"
  }

  validation {
    condition     = alltrue([for v in values(var.tags) : can(regex("^[a-z0-9:_.-]+$", v))])
    error_message = "Tag *values* may contain only lowercase letters, digits, colon (:), underscore (_), dash (-), and period (.)."
  }

  validation {
    condition     = length(var.tags) >= 2
    error_message = <<-EOT
      The *map* of tags must contain at least the following 2 elements.
      Minimum required tags are:
        us-mik:account-name = "finance-team-member"
        us-mik:cost-centre = "546.000.626.00"
    EOT
  }

  validation {
    condition     = length(var.tags) <= 40
    error_message = "The *map* of tags must contain 40 elements or less."
  }

  # mandatory account name
  validation {
    condition = anytrue([
      for key in keys(var.tags) : can(regex("^us-mik:account-name$", key))
    ])
    error_message = "A tag with the *key* of 'us-mik:account-name' is required"
  }

  # mandatory cost centre
  validation {
    condition = anytrue([
      for key in keys(var.tags) : can(regex("^us-mik:cost-centre$", key))
    ])
    error_message = "A tag with the *key* of 'us-mik:cost-centre' is required"
  }
}

variable "service_logging" {
  description = <<-EOT
    (Optional) Whether to enable service logging for the machine group.

    When true, the machine group will enable the platform service logging
    feature (if supported by the provider/region). Default is `false`.
  EOT
  type        = bool
  default     = false
}

