terraform {
  required_providers {
    kong = {
      source  = "philips-labs/kong"
      version = "6.630.0"
    }
  }
}

resource "kong_service" "service" {
  count = var.svc == null ? 0 : 1

  name            = jsondecode(file(var.svc)).name
  tags            = jsondecode(file(var.svc)).tags
  protocol        = jsondecode(file(var.svc)).protocol
  host            = jsondecode(file(var.svc)).host
  port            = jsondecode(file(var.svc)).port
  path            = jsondecode(file(var.svc)).path
  retries         = jsondecode(file(var.svc)).retries
  connect_timeout = jsondecode(file(var.svc)).connect_timeout
  read_timeout    = jsondecode(file(var.svc)).read_timeout
  write_timeout   = jsondecode(file(var.svc)).write_timeout
}

resource "kong_route" "route" {
  for_each = var.rt

  name           = jsondecode(file("${each.key}")).name
  tags           = jsondecode(file("${each.key}")).tags
  protocols      = jsondecode(file("${each.key}")).protocols
  strip_path     = jsondecode(file("${each.key}")).strip_path
  hosts          = jsondecode(file("${each.key}")).hosts
  paths          = jsondecode(file("${each.key}")).paths
  preserve_host  = jsondecode(file("${each.key}")).preserve_host
  path_handling  = jsondecode(file("${each.key}")).path_handling
  regex_priority = jsondecode(file("${each.key}")).regex_priority
  service_id     = kong_service.service[0].id
}

resource "kong_upstream" "upstream" {
  for_each = var.ups

  name                 = jsondecode(file("${each.key}")).name
  tags                 = jsondecode(file("${each.key}")).tags
  slots                = jsondecode(file("${each.key}")).slots
  host_header          = jsondecode(file("${each.key}")).host_header
  hash_on              = jsondecode(file("${each.key}")).hash_on
  hash_fallback        = jsondecode(file("${each.key}")).hash_fallback
  hash_on_header       = jsondecode(file("${each.key}")).hash_on_header
  hash_fallback_header = jsondecode(file("${each.key}")).hash_fallback_header
  hash_on_cookie       = jsondecode(file("${each.key}")).hash_on_cookie
  hash_on_cookie_path  = jsondecode(file("${each.key}")).hash_on_cookie_path
}

resource "kong_target" "target" {
  for_each = var.tgs

  tags        = jsondecode(file("${each.key}")).tags
  target      = jsondecode(file("${each.key}")).target
  weight      = jsondecode(file("${each.key}")).weight
  upstream_id = kong_upstream.upstream[replace(replace("${each.key}", "targets", "upstreams"), "-target", "")].id
}

resource "kong_plugin" "plugin" {
  for_each = var.pls

  name        = split("/", "${each.key}")[3]
  service_id  = jsondecode(file("${each.key}")).service == null ? null : kong_service.service[0].id
  route_id    = jsondecode(file("${each.key}")).route == null ? null : kong_route.route[replace(replace(replace("${each.key}", format("%s/", split("/", "${each.key}")[3]), ""), "plugins", "routes"), "-plugin", "-route")].id
  config_json = jsonencode(jsondecode(file("${each.key}")).config)
  enabled     = jsonencode(jsondecode(file("${each.key}")).enabled)
  depends_on  = [kong_service.service, kong_route.route, ]
}
