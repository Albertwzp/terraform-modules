variable "path" {
  type        = string
  description = "(Required) Where the secret backend will be mounted"
}

variable "type" {
  type        = string
  description = "(Required) Type of the backend, such as 'aws'"
}

variable "description" {
  type        = string
  default     = null
  description = "Human-friendly description of the mount"
}

variable "default_lease_ttl_seconds" {
  type        = number
  default     = 0
  description = "Default lease duration for tokens and secrets in seconds"
}

variable "max_lease_ttl_seconds" {
  type        = number
  default     = 0
  description = "Maximum possible lease duration for tokens and secrets in seconds"
}

variable "local" {
  type        = bool
  default     = false
  description = "Boolean flag that can be explicitly set to true to enforce local mount in HA environment"
}

variable "options" {
  type        = map
  default     = {}
  description = "Specifies mount type specific options that are passed to the backend"
}

variable "seal_wrap" {
  type        = bool
  default     = false
  description = "Boolean flag that can be explicitly set to true to enable seal wrapping for the mount, causing values stored by the mount to be wrapped by the seal's encryption capability"
}

#variable "vault-path" {
#  type = string
#}

variable "vault-json" {
  type = list(any)
}
