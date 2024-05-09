# Data source for AWS Availability Zones
# This data source is used to retrieve a list of Availability Zones that are currently available.
# The 'available' state filter ensures we only get zones where AWS resources can be deployed.
data "aws_availability_zones" "available" {
  state = "available"
}