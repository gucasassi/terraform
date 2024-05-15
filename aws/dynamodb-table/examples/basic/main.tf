# Define a Terraform module for managing a DynamoDB table
module "dynamodb" {

  source = "../.."

  hash_key   = "LockID"
  table_name = "my-table"

  attributes = [{
    type = "S"
    name = "LockID"
  }]

}