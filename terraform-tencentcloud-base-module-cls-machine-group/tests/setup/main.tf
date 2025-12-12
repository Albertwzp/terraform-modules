# Setup module to create test logset for machine group testing
resource "tencentcloud_cls_logset" "this" {
  logset_name = var.logset_name
  tags        = var.tags
}

