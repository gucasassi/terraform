
# Define a Terraform module for managing remote state storage.
# This module encapsulates the configuration for storing Terraform state remotely.
module "remote_state" {

  source = "../.."  # Set the source of the module to the relative path of your module
  name   = "simple" # Set the name of project to identify the remote state.

}