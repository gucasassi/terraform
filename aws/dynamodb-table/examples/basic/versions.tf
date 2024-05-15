# Terraform configuration
terraform {

  # Required version.
  required_version = ">= 1.0"

  # Required providers.
  required_providers {
    # AWS provider configuration
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.27"
    }
  }

}