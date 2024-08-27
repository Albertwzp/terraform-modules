/*variable "topic_name" {
  default	= "test"
}

variable "topic_lables" {
  default	= {}
  type		= map(string)
}

variable "retention" {
  default	= "604800s"
}


variable "sub_labels" {
  default	= {}
  type		= map(string)
}
*/

variable "project" {
  type		= string
}
variable "topic_sub" {
  default	= ""
  type		= string
}
