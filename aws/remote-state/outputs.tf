output "bucket" {
  description = "The unique identifier of the created S3 bucket."
  value       = module.s3-bucket.bucket_id
}

output "dynamodb_table" {
  description = "The ID of the DynamoDB table managed by the DynamoDB module."
  value       = module.dynamodb.table_id
}