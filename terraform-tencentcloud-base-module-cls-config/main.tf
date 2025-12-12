resource "tencentcloud_cls_config" "this" {
  name             = var.name
  path             = var.path
  log_type         = var.log_type
  output           = var.output
  user_define_rule = var.user_define_rule

  # Provider 1.82.x requires at least one extract_rule block.
  # For now we create an empty rule so the resource is valid; callers
  # can extend this module later if they need advanced parsing.
  extract_rule {}
}

