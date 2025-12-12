resource "tencentcloud_instance" "this" {
  # Core placement & identity
  availability_zone = var.availability_zone
  instance_name     = var.instance_name
  hostname          = var.hostname
  project_id        = var.project_id

  # Networking
  vpc_id    = var.vpc_id
  subnet_id = var.subnet_id

  private_ip                 = var.private_ip
  allocate_public_ip         = var.allocate_public_ip
  internet_charge_type       = var.internet_charge_type
  internet_max_bandwidth_out = var.internet_max_bandwidth_out

  # Compute & image
  image_id      = var.image_id
  instance_type = var.instance_type

  # System disk
  system_disk_type = var.system_disk_type
  system_disk_size = var.system_disk_size
  system_disk_id   = var.system_disk_id
  system_disk_name = var.system_disk_name

  # Optional data disks (simple mapping to provider schema)
  dynamic "data_disks" {
    for_each = var.data_disks
    content {
      data_disk_type               = data_disks.value.data_disk_type
      data_disk_size               = data_disks.value.data_disk_size
      data_disk_id                 = data_disks.value.data_disk_id
      data_disk_name               = data_disks.value.data_disk_name
      data_disk_snapshot_id        = data_disks.value.data_disk_snapshot_id
      delete_with_instance         = data_disks.value.delete_with_instance
      delete_with_instance_prepaid = data_disks.value.delete_with_instance_prepaid
      encrypt                      = data_disks.value.encrypt
      kms_key_id                   = data_disks.value.kms_key_id
      throughput_performance       = data_disks.value.throughput_performance
    }
  }

  # Billing
  instance_charge_type                    = var.instance_charge_type
  instance_charge_type_prepaid_period     = var.instance_charge_type_prepaid_period
  instance_charge_type_prepaid_renew_flag = var.instance_charge_type_prepaid_renew_flag
  force_delete                            = var.force_delete

  # Security
  disable_api_termination    = var.disable_api_termination
  disable_security_service   = var.disable_security_service
  disable_monitor_service    = var.disable_monitor_service
  disable_automation_service = var.disable_automation_service

  #security_groups         = var.security_groups
  orderly_security_groups = var.orderly_security_groups

  # Login & user data
  password = var.password
  #key_ids                     = var.key_ids
  keep_image_login            = var.keep_image_login
  user_data                   = var.user_data
  user_data_raw               = var.user_data_raw
  user_data_replace_on_change = var.user_data_replace_on_change

  # Spot & placement
  spot_instance_type = var.spot_instance_type
  spot_max_price     = var.spot_max_price
  #placement_group_id               = var.placement_group_id
  #force_replace_placement_group_id = var.force_replace_placement_group_id

  # Running state controls
  running_flag = var.running_flag
  stop_type    = var.stop_type
  stopped_mode = var.stopped_mode

  # EIP / Anti-DDoS integration
  ipv4_address_type    = var.ipv4_address_type
  bandwidth_package_id = var.bandwidth_package_id
  anti_ddos_package_id = var.anti_ddos_package_id
  release_address      = var.release_address

  # IPv6
  ipv6_address_count = var.ipv6_address_count
  ipv6_address_type  = var.ipv6_address_type

  # CAM / service roles
  cam_role_name = var.cam_role_name

  # Tags
  tags = var.tags
}
