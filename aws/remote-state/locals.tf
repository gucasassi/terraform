locals {
  # Generate a name for the remote state, optionally
  remote_name = "${var.name}-${var.name_suffix}-${random_id.this.dec}"
}