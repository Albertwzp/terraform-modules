# Setup module to create test logset, topic, config, and machine group for attachment testing
resource "tencentcloud_cls_logset" "this" {
  logset_name = var.logset_name
  tags        = var.tags
}

resource "tencentcloud_cls_topic" "this" {
  topic_name = var.topic_name
  logset_id  = tencentcloud_cls_logset.this.id
  tags       = var.tags
}

resource "tencentcloud_cls_config" "this" {
  name     = var.config_name
  path     = "/var/log/app.log"
  log_type = "json_log"

  # Minimal valid config under current provider: output/user_define_rule optional,
  # and at least one extract_rule block is required.
  extract_rule {}
}

resource "tencentcloud_cls_machine_group" "this" {
  group_name = var.machine_group_name

  machine_group_type {
    type   = "ip"
    values = ["192.168.1.1"]
  }

  tags = var.tags
}

