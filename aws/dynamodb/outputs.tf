output "table_id" {
  description = "The unique identifier of the DynamoDB table."
  value       = aws_dynamodb_table.this.id
}

output "table_arn" {
  description = "The Amazon Resource Name (ARN) of the DynamoDB table."
  value       = aws_dynamodb_table.this.arn
}
