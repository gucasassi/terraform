<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dynamodb"></a> [dynamodb](#module\_dynamodb) | ../dynamodb | n/a |
| <a name="module_s3-bucket"></a> [s3-bucket](#module\_s3-bucket) | ../s3-bucket | n/a |

## Resources

| Name | Type |
|------|------|
| [random_id.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The desired name to uniquely identify the remote state on AWS. | `string` | n/a | yes |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | A suffix to be appended to the name used for identifying the remote state on AWS. | `string` | `"remote-state"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | The unique identifier of the created S3 bucket. |
| <a name="output_dynamodb_table"></a> [dynamodb\_table](#output\_dynamodb\_table) | The ID of the DynamoDB table managed by the DynamoDB module. |
<!-- END_TF_DOCS -->