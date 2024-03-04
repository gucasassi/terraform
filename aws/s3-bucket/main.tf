# Generates a random ID to be used as a suffix for the S3 bucket name.
resource "random_id" "bucket_suffix" {
  count       = var.add_random_suffix ? 1 : 0
  byte_length = 5
}

# Provides a S3 bucket resource.
resource "aws_s3_bucket" "this" {

  bucket = local.name

  tags = {
    "Name" = local.name
  }

}

# Provides a S3 bucket server-side encryption configuration resource.For more information,
# see: https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {

  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}

# Provides an S3 bucket ACL resource. For more information,
# see: https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html
resource "aws_s3_bucket_acl" "this" {

  acl        = "private"
  bucket     = aws_s3_bucket.this.id
  depends_on = [aws_s3_bucket_ownership_controls.this]

}

# Provides a resource to manage S3 Bucket Ownership Controls. For more information,
# see: https://docs.aws.amazon.com/AmazonS3/latest/userguide/about-object-ownership.html
resource "aws_s3_bucket_ownership_controls" "this" {

  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "ObjectWriter"
  }

}

# Provides a resource for controlling versioning on an S3 bucket. For more information,
# see: https://docs.aws.amazon.com/AmazonS3/latest/userguide/manage-versioning-examples.html
resource "aws_s3_bucket_versioning" "this" {

  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }

}

# Manages S3 bucket-level Public Access Block configuration. For more information,
# see: https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html
resource "aws_s3_bucket_public_access_block" "this" {

  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}
