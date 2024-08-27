locals {
  subs = lookup(jsondecode(file(var.topic_sub)), "sub", null)
}
resource "google_pubsub_topic" "topic" {
  name		= split("/", jsondecode(file(var.topic_sub)).name)[length(split("/", jsondecode(file(var.topic_sub)).name))-1]
  labels	= lookup(jsondecode(file(var.topic_sub)), "labels", null)
  project	= var.project
  message_retention_duration = lookup(jsondecode(file(var.topic_sub)), "message_retention_duration", null)
}

resource "google_pubsub_subscription" "sub" {
  for_each = toset(keys(local.subs))
  name		= split("/", local.subs["${each.key}"].name)[length(split("/", local.subs["${each.key}"].name))-1]
  topic		= google_pubsub_topic.topic.name
  project	= var.project
  labels	= lookup(local.subs["${each.key}"], "labels", null)
  //push_config	= lookup(local.subs["${each.key}"], "pushConfig", null)
  ack_deadline_seconds		= lookup(local.subs["${each.key}"], "ackDeadlineSeconds", null)
  message_retention_duration 	= lookup(local.subs["${each.key}"], "message_retention_duration", null)
}
