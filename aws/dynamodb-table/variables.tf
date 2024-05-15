variable "table_name" {
  description = "An optional custom name for the DynamoDB table. If not provided, a default name will be generated."
  type        = string
}

variable "attributes" {
  description = "A list of maps specifying the name and type for each attribute in the DynamoDB table."
  type        = list(map(string))
}

variable "hash_key" {
  description = "The name of the attribute to be used as the hash (partition) key. It must also be defined as an attribute."
  type        = string
}

variable "enable_at_rest_encryption" {
  description = "Enable at-rest encryption for the DynamoDB table"
  type        = bool
  default     = true
}

variable "enable_point_in_time_recovery" {
  description = "Enable Point-in-Time Recovery (PITR) for the DynamoDB table"
  type        = bool
  default     = true
}