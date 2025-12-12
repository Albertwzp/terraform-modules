output "logset_id" {
  description = "ID of the created logset"
  value       = tencentcloud_cls_logset.this.id
}

output "logset_name" {
  description = "Name of the created logset"
  value       = tencentcloud_cls_logset.this.logset_name
}

output "topic_id" {
  description = "ID of the created log topic"
  value       = tencentcloud_cls_topic.this.id
}

output "topic_name" {
  description = "Name of the created log topic"
  value       = tencentcloud_cls_topic.this.topic_name
}

output "config_id" {
  description = "ID of the created log collection configuration"
  value       = tencentcloud_cls_config.this.id
}

output "config_name" {
  description = "Name of the created log collection configuration"
  value       = tencentcloud_cls_config.this.name
}

output "machine_group_id" {
  description = "ID of the created machine group"
  value       = tencentcloud_cls_machine_group.this.id
}

output "machine_group_name" {
  description = "Name of the created machine group"
  value       = tencentcloud_cls_machine_group.this.group_name
}

