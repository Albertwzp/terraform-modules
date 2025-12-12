output "machine_group_id" {
  description = "The ID of the created machine group"
  value       = tencentcloud_cls_machine_group.this.id
}

output "group_name" {
  description = "The name of the created machine group"
  value       = tencentcloud_cls_machine_group.this.group_name
}

output "machine_group_type" {
  description = "Type of the machine group (ip or label)"
  value       = tencentcloud_cls_machine_group.this.machine_group_type
}

output "tags" {
  description = "Tags associated with the machine group"
  value       = tencentcloud_cls_machine_group.this.tags
}

