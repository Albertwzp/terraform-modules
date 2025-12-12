output "attachment_id" {
  description = "The ID of the created config attachment"
  value       = tencentcloud_cls_config_attachment.this.id
}

output "config_id" {
  description = "The ID of the log collection configuration"
  value       = tencentcloud_cls_config_attachment.this.config_id
}

output "group_id" {
  description = "The ID of the machine group attached to the configuration"
  value       = tencentcloud_cls_config_attachment.this.group_id
}

