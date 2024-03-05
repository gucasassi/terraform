# Define a Terraform module to create an S3 bucket
module "s3" {
  source      = "../.."          # Set the source of the module to the relative path of your module
  bucket_name = "private-bucket" # Specify the name for the S3 bucket
}