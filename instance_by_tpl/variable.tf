variable "image_name" {
  default	= "debian-10-buster-v20211209"
}
variable "region" {
  default       = "us-central1"
}
variable "tpl_name" {
  default	= "sample-tpl"
}
variable "machine_type" {
  default	= "e2-micro"
}
variable "boot_disk_type" {
  default	= "pd-ssd"
  #default	= "pd-standard"
}
variable "disk_type" {
  default	= "pd-ssd"
}
variable "boot_disk_size" {
  type		= number
  default	= 100
}
variable "add_disk_size" {
  type		= number
  default	= 10
}
variable "add_disk_num" {
  type		= number
  default	= 0
}
variable "sa_email" {
  default	= ""
}
variable "scopes" {
  type		= list(string)
  default	= ["service-control", "service-management", "storage-ro", "trace", "logging-write", "monitoring-write"]
  #default	= ["cloud-platform"]
}
variable "is_public" {
  default	= false
}
variable "is_default_subnet" {
  default	= true
}
variable "subnetwork" {
  default	= ""
}
variable "subnetwork_project" {
  default	= ""
}
variable "tags" {
  type		= list(string)
  default	= []
}
variable "labels" {
  type		= map(string)
  default	= {}
}
variable "user" {
  default	= ""
}
variable "startup_script" {
  default	= <<EOF
apt update
EOF
}

variable "total" {
  type		= number
  default	= 1
}
variable "instance_prefix" {
  default	= "player"
}
variable "project" {
  description   = "assign project"
  default       = ""
}
variable "zone" {
  description   = "assign gcloud zone"
  default       = ""
}

/*variable "group_name" {
  description   = "instance_group mgr instance"
  default	= "sample"
}*/
