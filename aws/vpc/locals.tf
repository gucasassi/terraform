locals {
  # Selects the first three Availability Zones available in the current AWS region.
  # This local variable is used to limit subnet creation to a subset of available zones.
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}