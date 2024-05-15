################################################################################################################
###############################                IAM-ROLE                #########################################
################################################################################################################

# This Terraform resource block defines an IAM role for an Amazon EKS cluster.
# It specifies the assume role policy document allowing EKS to assume this role.
resource "aws_iam_role" "this" {

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  name               = "eks-cluster-${var.cluster_name}"

}

# This Terraform resource block attaches the AmazonEKS_Custer_Policy to the IAM role.
resource "aws_iam_role_policy_attachment" "cluster_policy" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.this.name

}

################################################################################################################
###############################                CLUSTER                 #########################################
################################################################################################################

# This Terraform resource block defines an Amazon EKS cluster.
# It specifies the name of the cluster, the IAM role for the cluster, and the VPC configuration.
resource "aws_eks_cluster" "this" {

  name     = var.cluster_name
  role_arn = aws_iam_role.this.arn

  version = var.cluster_version

  vpc_config {
    subnet_ids = var.vpc_subnet_ids
  }

  depends_on = [aws_iam_role_policy_attachment.cluster_policy]

}

################################################################################################################
###############################              NODE-GROUP                #########################################
################################################################################################################

# This Terraform module block defines a node group for the Amazon EKS cluster.
# It specifies the source of the module, the cluster name, and the VPC subnet IDs where the nodes will be deployed.
module "node_group" {

  source = "./modules/node_group"

  cluster_name = var.cluster_name

  capacity_type   = var.capacity_type
  desired_size    = var.desired_size
  instance_type   = var.instance_type
  max_size        = var.max_size
  max_unavailable = var.max_unavailable
  min_size        = var.min_size

  security_group_ids = concat([data.aws_security_group.cluster_sg.id], var.security_group_ids)
  vpc_subnet_ids     = data.aws_subnets.private.ids

  depends_on = [aws_eks_cluster.this]

}

################################################################################################################
###############################          CLUSTER-AUTOSCALER            #########################################
################################################################################################################

# This Terraform module block defines the configuration for the Kubernetes Cluster Autoscaler.
# It specifies the source of the module, the cluster name, and the issuer URL for the cluster's OIDC identity provider.
module "cluster_autoscaler" {

  source = "./modules/cluster_autoscaler"

  cluster_issuer = aws_eks_cluster.this.identity[0].oidc[0].issuer
  cluster_name   = var.cluster_name

  depends_on = [aws_eks_cluster.this]

}

################################################################################################################
###############################              SUBNET-TAGS               #########################################
################################################################################################################

# This Terraform resource block defines tags for Kubernetes internal ELBs.
# It associates the specified key-value pair with each subnet in the VPC.
resource "aws_ec2_tag" "kubernetes_role" {

  for_each = { for idx, subnet in var.vpc_subnet_ids : idx => subnet }

  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
  resource_id = each.value

}

# This Terraform resource block defines tags for the Kubernetes cluster.
# It associates the specified key-value pair with each subnet in the VPC, indicating ownership by the specified cluster.
resource "aws_ec2_tag" "kubernetes_cluster" {

  for_each = { for idx, subnet in var.vpc_subnet_ids : idx => subnet }

  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "owned"
  resource_id = each.value

}
