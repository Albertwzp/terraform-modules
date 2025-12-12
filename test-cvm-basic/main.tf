module "cvm" {
  source = "../terraform-tencentcloud-base-module-cvm-instance"

  vpc_id                  = "vpc-fs51mapb"    # Name of existing VPC to query
  subnet_id               = "subnet-76tazp06" # Name of existing subnet to query
  orderly_security_groups = ["sg-kff383l3"]   # Name of existing security group to query (optional)
  availability_zone       = "ap-guangzhou-3"  # Availability zone for subnet query

  # Required: Image and instance type
  image_id      = "img-eb30mz89" # Example image ID - adjust based on your region/AZ
  instance_type = "S5.MEDIUM2"   # Example instance type

  # Optional: Instance naming
  instance_name = "test-cvm-basic"
  hostname      = "test-cvm-basic"

  # Optional: System disk
  system_disk_type = "CLOUD_PREMIUM"
  system_disk_size = 20

  # Optional: Public IP
  allocate_public_ip         = false
  internet_max_bandwidth_out = null
  user_data = base64encode(<<-EOT
    #!/bin/bash
    echo "${var.SECRET_ID}" >/tmp/cvm.log
    yum install -y docker-ce
    yum install -y https://github.com/deviceinsight/kafkactl/releases/download/v5.16.0/kafkactl_5.16.0_linux_amd64.rpm
    curl -O /usr/loca/bin/kubectl -L https://dl.k8s.io/release/v1.34.0/bin/linux/amd64/kubectl && chmod +x /usr/local/bin/kubectl
    mkdir -p /tmp/loglistener/ && (wget -O /tmp/loglistener/install.sh http://mirrors.tencentyun.com/install/cls/install.sh || wget -O /tmp/loglistener/install.sh https://mirrors.tencent.com/install/cls/install.sh) && chmod +x /tmp/loglistener/install.sh
    echo "/tmp/loglistener/install.sh -s  -k  -r ap-guangzhou -n intra -e true -u false -l test-cvm-basic" >>/tmp/cvm.log
  EOT
  )
  #user_data_replace_on_change = true

  # Required: Tags
  tags = {
    "us-mik:account-name" = "finance-team-member"
    "us-mik:cost-centre"  = "546.000.626.00"
  }

}

#module "cls-logset" {
#  source = "../terraform-tencentcloud-base-module-cls-logset"
#
#  logset_name = "test-cvm-basic"
#  tags = {
#    "us-mik:account-name" = "finance-team-member"
#    "us-mik:cost-centre"  = "546.000.626.00"
#  }
#}
#
#module "cls-topic" {
#  source = "../terraform-tencentcloud-base-module-cls-topic"
#
#  topic_name = "test-cvm-basic"
#  logset_id  = module.cls-logset.logset_id
#  tags = {
#    "us-mik:account-name" = "finance-team-member"
#    "us-mik:cost-centre"  = "546.000.626.00"
#  }
#
#  #Individual topic configuration parameters
#  auto_split           = false
#  max_split_partitions = 20
#  partition_count      = 1
#  period               = 30
#  storage_type         = "hot"
#  describes            = "test cvm basic"
#  hot_period           = 10
#
#}
#
#module "cls-index" {
#  source = "../terraform-tencentcloud-base-module-cls-index"
#
#  topic_id = module.cls-topic.topic_id
#  rule = {
#    full_text = {
#      case_sensitive = false
#      tokenizer      = "***"
#      contain_z_h    = true
#    }
#
#    key_value = {
#      case_sensitive = false
#      key_values = [{
#        key = "LogParseFailure"
#        value = {
#          contain_z_h = true
#          sql_flag    = true
#          tokenizer   = "***"
#          type        = "text"
#        }
#      }]
#    }
#  }
#}
#
#module "cls-machine-group" {
#  source = "../terraform-tencentcloud-base-module-cls-machine-group"
#
#  group_name      = "test-cvm-basic"
#  service_logging = true
#  machine_group_type = {
#    type   = "label"
#    values = ["test-cvm-basic"]
#  }
#  tags = {
#    "us-mik:account-name" = "finance-team-member"
#    "us-mik:cost-centre"  = "546.000.626.00"
#  }
#}
#
#module "cls-config" {
#  source = "../terraform-tencentcloud-base-module-cls-config"
#
#  name     = "test-cvm-basic"
#  path     = "/var/log/**/*.log"
#  log_type = "minimalist_log"
#  output   = module.cls-topic.topic_id
#}
#
#module "cls-config-attachment" {
#  source = "../terraform-tencentcloud-base-module-cls-config-attachment"
#
#  config_id = module.cls-config.config_id
#  group_id  = module.cls-machine-group.machine_group_id
#}
