# Generates a random ID to be used as a suffix for the S3 bucket name.
resource "random_id" "this" {
  byte_length = 5
}

# Create Amazon S3 bucket to store the terraform state.
module "s3-bucket" {

  source            = "../s3-bucket"
  bucket_name       = local.remote_name
  add_random_suffix = false

}

# Create a Dynamodb table for tfstate locking.
module "dynamodb" {

  source     = "../dynamodb"
  table_name = "${local.remote_name}-locking"

}