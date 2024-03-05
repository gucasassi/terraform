<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | A list of maps specifying the name and type for each attribute in the DynamoDB table. | `list(map(string))` | <pre>[<br>  {<br>    "S": "LockID"<br>  }<br>]</pre> | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | The name of the attribute to be used as the hash (partition) key. It must also be defined as an attribute. | `string` | `"LockID"` | no |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | An optional custom name for the DynamoDB table. If not provided, a default name will be generated. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn) | The Amazon Resource Name (ARN) of the DynamoDB table. |
| <a name="output_table_id"></a> [table\_id](#output\_table\_id) | The unique identifier of the DynamoDB table. |
<!-- END_TF_DOCS -->