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

