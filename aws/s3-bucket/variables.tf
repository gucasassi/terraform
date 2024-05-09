variable "bucket_name" {
  description = "The desired name for the S3 bucket."
  type        = string
}

variable "add_random_suffix" {
  description = "Set to true to add a random suffix to the bucket name."
  type        = bool
  default     = true
}

variable "public_access" {
  description = "Set to true to make the bucket public, false to keep it private."
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Set to true to enable versioning for the S3 bucket, false to disable. Default is true."
  type        = bool
  default     = true
}