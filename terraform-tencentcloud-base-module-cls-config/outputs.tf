output "config_id" {
  description = "The ID of the created log collection configuration"
  value       = tencentcloud_cls_config.this.id
}

output "name" {
  description = "The name of the created log collection configuration"
  value       = tencentcloud_cls_config.this.name
}

output "path" {
  description = "Log file path configured for collection"
  value       = tencentcloud_cls_config.this.path
}

output "log_type" {
  description = "Log type configured for parsing"
  value       = tencentcloud_cls_config.this.log_type
}

output "output" {
  description = "Output format configured for the log collection (if set)"
  value       = tencentcloud_cls_config.this.output
}

