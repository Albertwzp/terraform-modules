variable "name" {
  type        = string
  description = "policy name"
}

variable "hcl" {
  type        = any
  description = "policy to apply"
}
