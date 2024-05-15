# This Terraform data block retrieves information about private subnets within the specified VPC.
# It filters subnets by the VPC ID and applies a tag filter to match subnets with names containing "private".
data "aws_subnets" "private" {

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Name = "*private*"
  }

}

# Define the assume role policy as a data block
data "aws_iam_policy_document" "assume_role_policy" {

  statement {

    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

  }

}

data "aws_security_group" "cluster_sg" {

  tags = {
    Name = "eks-cluster-sg-${var.cluster_name}-*"
  }

  depends_on = [aws_eks_cluster.this]

}