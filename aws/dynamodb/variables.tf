variable "table_name" {
  description = "An optional custom name for the DynamoDB table. If not provided, a default name will be generated."
  type        = string
}

variable "attributes" {
  description = "A list of maps specifying the name and type for each attribute in the DynamoDB table."
  type        = list(map(string))
  default = [{
    "S" = "LockID"
  }]
}

variable "hash_key" {
  description = "The name of the attribute to be used as the hash (partition) key. It must also be defined as an attribute."
  type        = string
  default     = "LockID"
}