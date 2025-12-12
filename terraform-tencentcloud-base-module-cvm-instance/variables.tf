############################
# Placement & identity
############################

variable "availability_zone" {
  description = <<-EOT
    (Required) Availability zone where the CVM will be created, e.g. "ap-guangzhou-4".

    Notes:
      - Must be a valid AZ that supports CVM in your region.
      - Often selected via data source `tencentcloud_zones` or as an input var per environment.
  EOT
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.availability_zone)) > 0
    error_message = "availability_zone must be a non-empty valid zone name (e.g. ap-guangzhou-4)."
  }
}

variable "instance_name" {
  description = <<-EOT
    (Optional) Human-readable name of the CVM instance.

    Provider rules:
      - Max length 128 characters.
      - Defaults to \"Terraform-CVM-Instance\" when omitted.
  EOT
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.instance_name == null || length(var.instance_name) <= 128
    error_message = "instance_name must be <= 128 characters."
  }
}

variable "hostname" {
  description = <<-EOT
    (Optional) Hostname inside the guest OS.

    Linux:
      - 2–60 chars, segments separated by '.', each segment letters/digits/hyphens.
    Windows:
      - 2–15 chars, letters/digits/hyphens, cannot be all digits.

    If null, Tencent Cloud will derive a default hostname from the image.
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "project_id" {
  description = <<-EOT
    (Optional) Project ID the instance belongs to. Defaults to 0 (default project).
  EOT
  type        = number
  default     = 0
  nullable    = false
}

############################
# Networking
############################

variable "vpc_id" {
  description = <<-EOT
    (Required) ID of the VPC in which to create the instance.

    Example:
      vpc_id = "vpc-xxxxxxxx"
  EOT
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", trimspace(var.vpc_id)))
    error_message = "vpc_id must look like vpc-xxxxxxxx (lowercase letters/digits after 'vpc-')."
  }
}

variable "subnet_id" {
  description = <<-EOT
    (Required) Subnet ID within the specified VPC for the primary ENI.

    Example:
      subnet_id = "subnet-xxxxxxxx"
  EOT
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^subnet-[a-z0-9]+$", trimspace(var.subnet_id)))
    error_message = "subnet_id must look like subnet-xxxxxxxx (lowercase letters/digits after 'subnet-')."
  }
}

variable "private_ip" {
  description = <<-EOT
    (Optional) Static private IP to assign in the subnet CIDR.
    If null, Tencent Cloud auto-assigns an available IP.
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "allocate_public_ip" {
  description = <<-EOT
    (Optional) Whether to allocate a public IPv4 for this instance.

    - true  : assign and bind a public EIP (subject to internet_* settings)
    - false : private-only instance

    Default is false (no public IP).
  EOT
  type        = bool
  default     = false
  nullable    = false
}

variable "internet_charge_type" {
  description = <<-EOT
    (Optional) Billing mode for public network egress.

    Allowed values:
      - BANDWIDTH_PREPAID
      - TRAFFIC_POSTPAID_BY_HOUR
      - BANDWIDTH_POSTPAID_BY_HOUR
      - BANDWIDTH_PACKAGE

    When null, follows instance charge type defaults.
  EOT
  type        = string
  default     = null
  nullable    = true

  validation {
    condition = (
      var.internet_charge_type == null
      || contains(["BANDWIDTH_PREPAID", "TRAFFIC_POSTPAID_BY_HOUR", "BANDWIDTH_POSTPAID_BY_HOUR", "BANDWIDTH_PACKAGE"], var.internet_charge_type)
    )
    error_message = "internet_charge_type must be one of: BANDWIDTH_PREPAID, TRAFFIC_POSTPAID_BY_HOUR, BANDWIDTH_POSTPAID_BY_HOUR, BANDWIDTH_PACKAGE."
  }
}

variable "internet_max_bandwidth_out" {
  description = <<-EOT
    (Optional) Max outbound public bandwidth (Mbps).

    Effective only when allocate_public_ip = true.
  EOT
  type        = number
  default     = null
  nullable    = true

  validation {
    condition     = var.internet_max_bandwidth_out == null || (var.internet_max_bandwidth_out > 0 && var.internet_max_bandwidth_out <= 2000)
    error_message = "internet_max_bandwidth_out must be between 1 and 2000 Mbps when specified."
  }
}

############################
# Compute & Image
############################

variable "image_id" {
  description = <<-EOT
    (Required) Image ID to use for the instance.

    Typical sources:
      - data.tencentcloud_images
      - console-discovered custom images
  EOT
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.image_id)) > 0
    error_message = "image_id must be a non-empty string."
  }
}

variable "instance_type" {
  description = <<-EOT
    (Required) Instance type (flavor), e.g. \"S5.MEDIUM4\".

    Typically discovered via data source `tencentcloud_instance_types` with filters.
  EOT
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.instance_type)) > 0
    error_message = "instance_type must be a non-empty string (e.g. S5.MEDIUM4)."
  }
}

############################
# System disk
############################

variable "system_disk_type" {
  description = <<-EOT
    (Optional) System disk type.

    Common values (see official docs):
      - CLOUD_PREMIUM
      - CLOUD_SSD
      - CLOUD_HSSD
      - CLOUD_TSSD
      - CLOUD_BSSD

    If null, provider default applies.
  EOT
  type        = string
  default     = "CLOUD_PREMIUM"
  nullable    = false
}

variable "system_disk_size" {
  description = <<-EOT
    (Optional) System disk size in GB.
    Default is 50GB in provider; here we keep it explicit for clarity.
  EOT
  type        = number
  default     = 50
  nullable    = false

  validation {
    condition     = var.system_disk_size >= 20 && var.system_disk_size <= 500
    error_message = "system_disk_size must be between 20 and 500 GB."
  }
}

variable "system_disk_id" {
  description = <<-EOT
    (Optional) Existing system disk snapshot ID to initialize from.
    Not supported for LOCAL_* disk types.
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "system_disk_name" {
  description = <<-EOT
    (Optional) Name of the system disk.
  EOT
  type        = string
  default     = null
  nullable    = true
}

############################
# Data disks (list)
############################

variable "data_disks" {
  description = <<-EOT
    (Optional) List of data disk configurations attached to the instance.

    This maps 1:1 to the provider's data_disks block. Most fields are optional;
    minimal case requires data_disk_type and data_disk_size.
  EOT
  type = list(object({
    data_disk_type               = string
    data_disk_size               = number
    data_disk_id                 = optional(string)
    data_disk_name               = optional(string)
    data_disk_snapshot_id        = optional(string)
    delete_with_instance         = optional(bool)
    delete_with_instance_prepaid = optional(bool)
    encrypt                      = optional(bool)
    kms_key_id                   = optional(string)
    throughput_performance       = optional(number)
  }))
  default  = []
  nullable = false
}

############################
# Billing
############################

variable "instance_charge_type" {
  description = <<-EOT
    (Optional) Billing mode for the instance.

    Allowed values:
      - POSTPAID_BY_HOUR (default)
      - PREPAID
      - SPOTPAID
      - CDHPAID
      - CDCPAID
  EOT
  type        = string
  default     = "POSTPAID_BY_HOUR"
  nullable    = false

  validation {
    condition = contains(
      ["PREPAID", "POSTPAID_BY_HOUR", "SPOTPAID", "CDHPAID", "CDCPAID"],
      var.instance_charge_type
    )
    error_message = "instance_charge_type must be one of: PREPAID, POSTPAID_BY_HOUR, SPOTPAID, CDHPAID, CDCPAID."
  }
}

variable "instance_charge_type_prepaid_period" {
  description = <<-EOT
    (Optional) PREPAID subscription period in months.
    Only valid when instance_charge_type = PREPAID.

    Allowed values: 1,2,3,4,5,6,7,8,9,10,11,12,24,36,48,60.
  EOT
  type        = number
  default     = null
  nullable    = true
}

variable "instance_charge_type_prepaid_renew_flag" {
  description = <<-EOT
    (Optional) PREPAID auto-renew flag.

    Allowed values:
      - NOTIFY_AND_AUTO_RENEW
      - NOTIFY_AND_MANUAL_RENEW (default)
      - DISABLE_NOTIFY_AND_MANUAL_RENEW
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "force_delete" {
  description = <<-EOT
    (Optional) For PREPAID CVMs, whether to force permanent deletion instead of recycle bin.
    Default false.
  EOT
  type        = bool
  default     = false
  nullable    = false
}

############################
# Security & Services
############################

variable "disable_api_termination" {
  description = <<-EOT
    (Optional) Whether to enable termination protection.

    - true  : instance cannot be deleted via API until disabled.
    - false : default; deletion allowed.
  EOT
  type        = bool
  default     = false
  nullable    = false
}

variable "disable_security_service" {
  description = "(Optional) Disable security enhancement service (agent); default false (enabled)."
  type        = bool
  default     = false
  nullable    = false
}

variable "disable_monitor_service" {
  description = "(Optional) Disable monitor enhancement service; default false (enabled)."
  type        = bool
  default     = false
  nullable    = false
}

variable "disable_automation_service" {
  description = "(Optional) Disable automation enhancement service; default false (enabled)."
  type        = bool
  default     = false
  nullable    = false
}

variable "security_groups" {
  description = <<-EOT
    (Optional, Deprecated upstream) Security group IDs set.
    Prefer `orderly_security_groups` for deterministic ordering.
  EOT
  type        = set(string)
  default     = []
  nullable    = false
}

variable "orderly_security_groups" {
  description = <<-EOT
    (Optional) Ordered list of security group IDs bound to the primary ENI.

    Recommended over `security_groups` to avoid diff noise due to ordering.
  EOT
  type        = list(string)
  default     = []
  nullable    = false
}

############################
# Login & User Data
############################

variable "password" {
  description = <<-EOT
    (Optional) Login password for the instance.

    If you use key-based login only, leave this null.
  EOT
  type        = string
  default     = null
  nullable    = true
  sensitive   = true
}

variable "key_ids" {
  description = <<-EOT
    (Optional) List of SSH key IDs to bind for login, e.g. [\"skey-xxxxxx\"].
  EOT
  type        = list(string)
  default     = []
  nullable    = false
}

variable "keep_image_login" {
  description = <<-EOT
    (Optional) Whether to keep image-level login settings (for custom/shared/imported images).
  EOT
  type        = bool
  default     = false
  nullable    = false
}

variable "user_data" {
  description = <<-EOT
    (Optional) Base64-encoded user_data to inject into the instance.
    Conflicts with user_data_raw.
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "user_data_raw" {
  description = <<-EOT
    (Optional) Plain-text user_data; provider encodes.
    Conflicts with user_data.
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "user_data_replace_on_change" {
  description = <<-EOT
    (Optional) If true, changes to user_data/user_data_raw force recreation of the instance.
  EOT
  type        = bool
  default     = false
  nullable    = false
}

############################
# Spot & placement
############################

variable "spot_instance_type" {
  description = <<-EOT
    (Optional) Spot type; only \"ONE-TIME\" is currently valid.
    Requires instance_charge_type = SPOTPAID.
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "spot_max_price" {
  description = <<-EOT
    (Optional) Maximum price for spot billing, as decimal string (e.g. \"0.50\").
    Requires instance_charge_type = SPOTPAID.
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "placement_group_id" {
  description = <<-EOT
    (Optional) Placement group ID for anti-affinity / high-availability.
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "force_replace_placement_group_id" {
  description = <<-EOT
    (Optional) When changing placement_group_id, whether to allow host migration.
  EOT
  type        = bool
  default     = false
  nullable    = false
}

############################
# Running state
############################

variable "running_flag" {
  description = <<-EOT
    (Optional) Desired running state.

    - true  : instance should be running.
    - false : instance should be stopped (with stop_type / stopped_mode semantics).
  EOT
  type        = bool
  default     = true
  nullable    = false
}

variable "stop_type" {
  description = <<-EOT
    (Optional) Shutdown mode when stopping an instance.
    Allowed: SOFT_FIRST, HARD, SOFT.
  EOT
  type        = string
  default     = "SOFT_FIRST"
  nullable    = false
}

variable "stopped_mode" {
  description = <<-EOT
    (Optional) Billing mode after shutdown for pay-as-you-go instances.
    Allowed: KEEP_CHARGING, STOP_CHARGING.
  EOT
  type        = string
  default     = "KEEP_CHARGING"
  nullable    = false
}

############################
# EIP / Anti-DDoS
############################

variable "ipv4_address_type" {
  description = <<-EOT
    (Optional) IPv4 address type when allocating public IP.

    Examples:
      - WanIP (default)
      - HighQualityEIP
      - AntiDDoSEIP
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "bandwidth_package_id" {
  description = <<-EOT
    (Optional) Bandwidth package ID when using BANDWIDTH_PACKAGE billing.
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "anti_ddos_package_id" {
  description = <<-EOT
    (Optional) Anti-DDoS service package ID, required when requesting AntiDDoSEIP.
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "release_address" {
  description = <<-EOT
    (Optional) Whether to release the bound EIP when destroying the instance.
    Default false.
  EOT
  type        = bool
  default     = false
  nullable    = false
}

############################
# IPv6 & CAM
############################

variable "ipv6_address_count" {
  description = <<-EOT
    (Optional) Number of IPv6 addresses to allocate for the primary ENI.
  EOT
  type        = number
  default     = null
  nullable    = true
}

variable "ipv6_address_type" {
  description = <<-EOT
    (Optional) IPv6 address type (WanIP / EIPv6 / HighQualityEIPv6 etc.).
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "cam_role_name" {
  description = <<-EOT
    (Optional) CAM role name authorized to access other Tencent Cloud services.
  EOT
  type        = string
  default     = null
  nullable    = true
}

############################
# Tags (HKJC standard)
############################

variable "tags" {
  description = <<-EOT
    (Required) Key-value pairs for categorizing and organizing resources.

    Requirements:
    - Must be a map of string key-value pairs.
    - Useful for resource management, cost allocation, and access control.
    - Must include mandatory tags: us-mik:account-name and us-mik:cost-centre.

    Example: {
      us-mik:account-name = "finance-team-member"
      us-mik:cost-centre = "546.000.626.00"
    }
    EOT
  type        = map(string)

  # key length: 127 max
  validation {
    condition     = alltrue([for k in keys(var.tags) : length(k) <= 127])
    error_message = "Tag *keys* are restricted to a maximum of 127 characters."
  }

  # check value length. 255 max
  validation {
    condition     = alltrue([for v in values(var.tags) : length(v) <= 255])
    error_message = "Tag *values* are restricted to a maximum of 255 characters."
  }

  validation {
    condition = alltrue([
      for key in keys(var.tags) : can(regex("^[a-z0-9:-]+$|^Name$", key))
    ])
    error_message = "Tag *keys* allow only the following characters: lowercase letters, 0 to 9, colon, and dash: [a-z0-9:-], Or Name with an uppercase 'N'"
  }

  validation {
    condition     = alltrue([for v in values(var.tags) : can(regex("^[a-z0-9:_.-]+$", v))])
    error_message = "Tag *values* may contain only lowercase letters, digits, colon (:), underscore (_), dash (-), and period (.)."
  }

  validation {
    condition     = length(var.tags) >= 2
    error_message = <<-EOT
      The *map* of tags must contain at least the following 2 elements.
      Minimum required tags are:
        us-mik:account-name = "finance-team-member"
        us-mik:cost-centre = "546.000.626.00"
    EOT
  }

  validation {
    condition     = length(var.tags) <= 40
    error_message = "The *map* of tags must contain 40 elements or less."
  }

  # mandatory account name
  validation {
    condition = anytrue([
      for key in keys(var.tags) : can(regex("^us-mik:account-name$", key))
    ])
    error_message = "A tag with the *key* of 'us-mik:account-name' is required"
  }

  # mandatory cost centre
  validation {
    condition = anytrue([
      for key in keys(var.tags) : can(regex("^us-mik:cost-centre$", key))
    ])
    error_message = "A tag with the *key* of 'us-mik:cost-centre' is required"
  }
}