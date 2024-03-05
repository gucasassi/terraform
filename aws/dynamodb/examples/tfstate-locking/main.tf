# Define a Terraform module for managing a DynamoDB table
module "dynamodb" {
  source     = "../.."
  table_name = "tfstate-locking"
}