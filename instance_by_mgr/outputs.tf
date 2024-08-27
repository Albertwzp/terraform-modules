output "tpl_id" {
  value = google_compute_instance_template.tpl.id
}

output "group_id" {
  value = google_compute_instance_group_manager.instance-group-manager.instance_group
}

output "instance_group_manager_id" {
  value = google_compute_instance_group_manager.instance-group-manager.id
}

/*output "instance_ip" {
  value = google_compute_instance_from_template.ins.*.network_interface.0.network_ip
}*/
