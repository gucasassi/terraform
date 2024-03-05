variable "name" {
  description = "The desired name to uniquely identify the remote state on AWS."
  type        = string
}

variable "name_suffix" {
  description = "A suffix to be appended to the name used for identifying the remote state on AWS."
  type        = string
  default     = "remote-state"
}
