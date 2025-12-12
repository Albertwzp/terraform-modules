output "logset_id" {
  description = "ID of the created logset"
  value       = tencentcloud_cls_logset.this.id
}

output "logset_name" {
  description = "Name of the created logset"
  value       = tencentcloud_cls_logset.this.logset_name
}

