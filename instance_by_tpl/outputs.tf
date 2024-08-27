output "tpl_id" {
  value = google_compute_instance_template.tpl.id
}

/*output "group_id" {
  value = google_compute_instance_group.group.id
}*/

output "instance_ip" {
  value = google_compute_instance_from_template.ins.*.network_interface.0.network_ip
}

/*output "public_ip" {
  value = google_compute_instance_from_template.ins.*.network_interface.0.access_config.0.nat_ip
}*/
