variable "logset_name" {
  description = <<-EOT
    (Required) The name of the logset.
    Must be a non-empty string.
    Example: "cls_logset"
    EOT
  type        = string
}

variable "topic_name" {
  description = <<-EOT
    (Required) The name of the log topic.
    Must be a non-empty string.
    Example: "cloud_us-mik_cls_log_prod"
    EOT
  type        = string
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

