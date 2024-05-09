locals {
  # Generate a name for the S3 bucket, optionally appending a random suffix
  name = var.add_random_suffix ? "${var.bucket_name}-${random_id.bucket_suffix[0].dec}" : var.bucket_name
}