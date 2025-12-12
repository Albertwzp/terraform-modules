variable "config_id" {
  description = <<-EOT
    (Required) The ID of the log collection configuration to attach.
    Must be a valid CLS config ID in UUID format (8-4-4-4-12 hexadecimal digits).
    Example:
      config_id = "93685536-22de-44ca-99aa-2800d36fbb6e"
    EOT
  type        = string
  validation {
    condition     = can(regex("^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$", var.config_id))
    error_message = "config_id must be a valid UUID format (e.g., 93685536-22de-44ca-99aa-2800d36fbb6e)."
  }
}

variable "group_id" {
  description = <<-EOT
    (Required) Machine group ID to attach the log collection configuration to.
    
    Associates the log collection configuration with a specific machine group,
    enabling log collection from all machines in that group. The machine group
    must exist before creating this attachment.
    
    Usage Notes:
    - Must be a valid machine group ID in UUID format
    - Machine group must exist before creating the attachment
    - One config can be attached to multiple machine groups
    - Attachment enables log collection from machines in the group
    
    Example:
      group_id = "93685536-22de-44ca-99aa-2800d36fbb6e"
  EOT
  type        = string
  validation {
    condition     = can(regex("^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$", var.group_id))
    error_message = "group_id must be a valid UUID format (e.g., 93685536-22de-44ca-99aa-2800d36fbb6e)."
  }
}

