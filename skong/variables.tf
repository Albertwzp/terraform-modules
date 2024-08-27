variable "svc" {
  type	= string
  description	= "kong_service"
}

variable "rt" {
  type	= set(string)
  description	= "kong_route"
}

variable "ups" {
  type	= set(string)
  description	= "kong_upstream"
}

variable "tgs" {
  type	= set(string)
  description	= "kong_target dir"
}

variable "pls" {
  type	= set(string)
  description	= "kong_plugin dir"
}
