resource "tencentcloud_cls_machine_group" "this" {
  group_name = var.group_name

  machine_group_type {
    type   = var.machine_group_type.type
    values = var.machine_group_type.values
  }

  service_logging = var.service_logging

  tags = var.tags
}