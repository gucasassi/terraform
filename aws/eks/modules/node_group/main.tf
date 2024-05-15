################################################################################################################
###############################                IAM-ROLE                #########################################
################################################################################################################

# This Terraform resource block defines an IAM role for an Amazon EKS node group.
# It specifies the name of the IAM role and the policy document that allows EC2 instances to assume the role.
resource "aws_iam_role" "this" {

  name               = "eks-node-group-${var.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

}

# This Terraform resource block attaches the Amazon EKS worker node policy to an IAM role.
# It specifies the IAM role and the ARN of the policy to attach.
resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {

  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

}

# This Terraform resource block attaches the Amazon EKS CNI policy to an IAM role.
# It specifies the IAM role and the ARN of the policy to attach.
resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {

  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

}

# This Terraform resource block attaches the Amazon EC2 Container Registry read-only policy to an IAM role.
# It specifies the IAM role and the ARN of the policy to attach.
resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {

  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

}

################################################################################################################
###############################              NODE-GROUP                #########################################
################################################################################################################

# This Terraform resource block defines a launch template for Amazon EKS nodes.
# It specifies the launch template's name prefix, instance type, and tag specifications for instances created from the template.
resource "aws_launch_template" "eks_nodes" {

  instance_type          = var.instance_type
  name_prefix            = "${var.cluster_name}-eks-node"
  vpc_security_group_ids = var.security_group_ids

  tag_specifications {

    resource_type = "instance"

    tags = {
      Name = "${var.cluster_name}-eks-node"
    }

  }

}

# This Terraform resource block defines an Amazon EKS node group for private nodes.
# It specifies the cluster name, node role, node group name, subnet IDs, instance types, scaling configuration, update configuration, labels, and lifecycle settings.
resource "aws_eks_node_group" "private-nodes" {

  cluster_name = var.cluster_name

  node_role_arn   = aws_iam_role.this.arn
  node_group_name = "${var.cluster_name}-private-nodes"

  subnet_ids    = var.vpc_subnet_ids
  capacity_type = var.capacity_type

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = var.max_unavailable
  }

  labels = {
    role = "general"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size, launch_template[0].version]
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]

}

