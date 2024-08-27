locals {
  boot_disk = [
    {
      source_image = var.image_name
      auto_delete  = true
      disk_type	   = var.disk_type
      disk_size_gb = var.boot_disk_size
      boot         = true
    },
  ]
  add_disks = [
  for i in range(var.add_disk_num):
  {
    auto_delete	= true
    disk_type	= var.disk_type
    disk_size_gb= var.add_disk_size
    boot	= false
  }
  if var.add_disk_num > 0
  ]
  all_disks = concat(local.boot_disk, local.add_disks)
}

data "google_compute_zones" "available" {
  region	= var.region
  project	= var.project
  status	= "UP"
}
resource "google_compute_instance_template" "tpl" {
  name_prefix  = var.tpl_name
  machine_type = var.machine_type
  project      = var.project
  region       = var.region

  dynamic "disk" {
    for_each = local.all_disks
    content {
      device_name  = lookup(disk.value, "device_name", null)
      disk_name    = lookup(disk.value, "disk_name", null)
      source_image = lookup(disk.value, "source_image", null)
      auto_delete  = lookup(disk.value, "auto_delete", null)
      disk_type    = lookup(disk.value, "disk_type", null)
      disk_size_gb = lookup(disk.value, "disk_size_gb", null)
      boot         = lookup(disk.value, "boot", null)
    }
  }

  dynamic "network_interface" {
    for_each	= var.is_default_subnet ? [""] : []
    content {
      network	= "default"
    }
  }
  dynamic "network_interface" {
    for_each	= var.is_default_subnet ? [] : [""]
    content {
      subnetwork	= var.subnetwork
      subnetwork_project = var.subnetwork_project
      dynamic "access_config" {
        for_each = var.is_public ? [""] : []
        content {
          network_tier = "PREMIUM"
        }
      }
    }
  }

  tags     = var.tags
  labels   = var.labels
  metadata = {
    ssh-keys = "${var.user}:${file("./key/authorized_keys")}"
    enable-oslogin	= true
#    user-data		= data.template_file.user_data.rendered
  }
  metadata_startup_script = "${var.startup_script}"

  can_ip_forward = false
  service_account {
    email  = var.sa_email
    scopes = ["cloud-platform"]
  }

  shielded_instance_config {
    enable_vtpm = true
    enable_integrity_monitoring = true
  }

  /*reservation_affinity {
    type = any
  }*/

  scheduling {
    on_host_maintenance = "MIGRATE"
    automatic_restart   = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "google_compute_instance_group_manager" "instance-group-manager" {
  name			= var.group_name
  base_instance_name	= var.instance_prefix
  project		= var.project
  zone			= var.zone
  target_size		= var.total

  version {
    name		= "init"
    instance_template	= google_compute_instance_template.tpl.id
  }
  named_port {
    name = "ssh"
    port = 22
  }

  auto_healing_policies {
    health_check	= google_compute_health_check.auto-health-check.id
    initial_delay_sec	= 300
  }
}

resource "google_compute_health_check" "auto-health-check" {
  project	= var.project
  name		= "tcp-health-check"
  timeout_sec	= 3
  check_interval_sec	= 5

  tcp_health_check {
    port  = "22"
  }

  log_config {
    enable = true
  }
}
