# Provides a DynamoDB table resource.
# tfsec:ignore:aws-dynamodb-table-customer-key
resource "aws_dynamodb_table" "this" {

  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.hash_key

  dynamic "attribute" {

    for_each = var.attributes

    content {
      name = attribute.value["name"]
      type = attribute.value["type"]
    }

  }

  server_side_encryption {
    enabled = var.enable_at_rest_encryption
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  tags = {
    "Name" = var.table_name
  }

}