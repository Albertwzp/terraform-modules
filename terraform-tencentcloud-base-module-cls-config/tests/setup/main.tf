# Setup module to create test logset and topic for config testing
resource "tencentcloud_cls_logset" "this" {
  logset_name = var.logset_name
  tags        = var.tags
}

resource "tencentcloud_cls_topic" "this" {
  topic_name = var.topic_name
  logset_id  = tencentcloud_cls_logset.this.id
  tags       = var.tags
}

