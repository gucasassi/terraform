output "bucket_id" {
  description = "The unique identifier of the created S3 bucket."
  value       = aws_s3_bucket.this.id
}