variable "bucket_name" {
  description = "The desired name for the S3 bucket."
  type        = string
}

variable "add_random_suffix" {
  description = "Set to true to add a random suffix to the bucket name."
  type        = bool
  default     = true
}