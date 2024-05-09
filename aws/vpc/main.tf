################################################################################################################
###############################                  VPC                   #########################################
################################################################################################################

# This Terraform resource block defines an AWS Virtual Private Cloud (VPC) configuration.
# It allows customization of VPC settings such as CIDR block, DNS support, and DNS hostnames.
# Tags are also applied for easy identification and management within AWS.
resource "aws_vpc" "this" {

  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "${var.name}"
  }

}

################################################################################################################
###############################                SUBNETS                 #########################################
################################################################################################################

# This Terraform resource block defines the creation of public subnets within the VPC. 
# Public subnets typically host resources that require direct access to the internet. 
# Each public subnet is associated with an availability zone and can optionally have public IP addresses mapped to instances launched within it.
resource "aws_subnet" "public" {

  for_each = { for idx, cidr in var.public_subnets : idx => cidr }

  availability_zone       = element(local.azs, each.key)
  cidr_block              = each.value
  map_public_ip_on_launch = var.map_public_ip_on_launch
  vpc_id                  = aws_vpc.this.id

  tags = {
    Name = format("${var.name}-${var.public_subnet_suffix}-%s", element(local.azs, each.key))
  }

}

# This Terraform resource block defines the creation of private subnets within the VPC. 
# Private subnets are typically used for resources that do not require direct internet access. 
# They are associated with specific availability zones and are suitable for hosting internal-facing resources.
resource "aws_subnet" "private" {

  for_each = { for idx, cidr in var.private_subnets : idx => cidr }

  availability_zone = element(local.azs, each.key)
  cidr_block        = each.value
  vpc_id            = aws_vpc.this.id

  tags = {
    Name = format("${var.name}-${var.private_subnet_suffix}-%s", element(local.azs, each.key))
  }

}

################################################################################################################
###############################                  IGW                   #########################################
################################################################################################################

# This Terraform resource block defines the creation of an Internet Gateway (IGW) for the VPC.
# An Internet Gateway allows communication between instances in the VPC and the internet.
resource "aws_internet_gateway" "this" {

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-igw"
  }

}

################################################################################################################
###############################                  EIP                   #########################################
################################################################################################################

# This Terraform resource block defines the creation of Elastic IPs (EIPs) for NAT Gateways.
# Depending on the configuration, it either creates a single shared EIP for a NAT Gateway serving all private networks,
# or creates individual EIPs for each private subnet within the VPC.
resource "aws_eip" "ngw" {

  for_each = var.single_nat_gateway ? { single = 1 } : { for idx, _ in var.private_subnets : idx => idx }

  tags = {
    Name = var.single_nat_gateway ? "${var.name}-shared-ngw" : format("${var.name}-${var.private_subnet_suffix}-%s-ngw", element(local.azs, each.key))
  }

}

################################################################################################################
###############################                 NAT-GW                 #########################################
################################################################################################################

# This Terraform resource block defines the creation of a NAT Gateway in each public subnet for outbound internet traffic.
# NAT Gateways allow instances in private subnets to initiate outbound traffic to the internet while preventing inbound traffic from initiating a connection with them.
resource "aws_nat_gateway" "this" {

  for_each = var.single_nat_gateway ? { single = 1 } : { for idx, _ in var.private_subnets : idx => idx }

  allocation_id = var.single_nat_gateway ? aws_eip.ngw["single"].id : aws_eip.ngw[each.key].id
  subnet_id     = var.single_nat_gateway ? aws_subnet.public[0].id : aws_subnet.public[each.key].id

  tags = {
    Name = var.single_nat_gateway ? "${var.name}-shared-ngw" : format("${var.name}-%s-ngw", element(local.azs, each.key))
  }

  depends_on = [aws_internet_gateway.this]

}

################################################################################################################
###############################                 ROUTES                 #########################################
################################################################################################################

# This Terraform resource block defines the creation of a route table for private subnets within the VPC.
# It's used to route outbound traffic from private subnets to the NAT Gateway.
resource "aws_route_table" "private" {

  vpc_id = aws_vpc.this.id

  route = [
    {
      carrier_gateway_id         = ""
      cidr_block                 = "0.0.0.0/0"
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      gateway_id                 = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      nat_gateway_id             = aws_nat_gateway.this["single"].id
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    },
  ]

  tags = {
    Name = "${var.name}-${var.private_subnet_suffix}-subnets"
  }

}

# This Terraform resource block defines the association of private subnets with the private route table.
# It ensures that outbound traffic from private subnets is routed through the NAT Gateway.
resource "aws_route_table_association" "private" {

  for_each = { for idx, subnet in aws_subnet.private : idx => subnet }

  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[each.key].id

}

# This Terraform resource block defines the creation of a route table for public subnets within the VPC.
# Route tables are used to define how network traffic should be directed within the VPC.
resource "aws_default_route_table" "this" {

  default_route_table_id = aws_vpc.this.default_route_table_id

  route = [
    {
      carrier_gateway_id         = ""
      cidr_block                 = "0.0.0.0/0"
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      gateway_id                 = aws_internet_gateway.this.id
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      nat_gateway_id             = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    },
  ]

  tags = {
    Name = "${var.name}-${var.public_subnet_suffix}-subnets"
  }

}

# This Terraform resource block defines the association of public subnets with the public route table.
# Each public subnet in the VPC is associated with the public route table to manage the routing of network traffic.
resource "aws_route_table_association" "public" {

  for_each = { for idx, subnet in aws_subnet.public : idx => subnet }

  route_table_id = aws_default_route_table.this.id
  subnet_id      = each.value.id

}

