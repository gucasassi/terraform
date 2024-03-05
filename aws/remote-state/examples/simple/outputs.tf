output "bucket" {
  description = "The unique identifier of the created S3 bucket."
  value       = module.remote_state.bucket
}

output "dynamodb_table" {
  description = "The ID of the DynamoDB table managed by the DynamoDB module."
  value       = module.remote_state.dynamodb_table
}