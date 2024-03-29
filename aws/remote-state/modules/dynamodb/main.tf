# Provides a DynamoDB table resource.
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

  tags = {
    "Name" = var.table_name
  }

}