################################################################################################################
###############################                  OIDC                  #########################################
################################################################################################################

# This Terraform resource block defines an OpenID Connect (OIDC) provider for an Amazon EKS cluster.
# It configures the OIDC provider to use the specified cluster issuer URL and allows the specified client ID to authenticate.
resource "aws_iam_openid_connect_provider" "eks" {

  url             = var.cluster_issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]

}

################################################################################################################
###############################                  ROLES                 #########################################
################################################################################################################

# This Terraform resource block defines an IAM role for the Amazon EKS cluster autoscaler.
# It configures the IAM role with the specified name and attach the assume role policy obtained from the data source.
resource "aws_iam_role" "eks_cluster_autoscaler" {

  name               = "eks-cluster-autoscaler"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_autoscaler_assume_role_policy.json

}

###############################################################################################################
###############################                  POLICY                #########################################
################################################################################################################

# This Terraform resource block defines an IAM policy for the Amazon EKS cluster autoscaler.
# It specifies the name of the policy and uses a pre-defined IAM policy document obtained from a data source.
resource "aws_iam_policy" "eks_cluster_autoscaler" {

  name   = "eks-cluster-autoscaler"
  policy = data.aws_iam_policy_document.eks_cluster_autoscaler.json

}

# This Terraform resource block attaches an IAM policy to an IAM role for the Amazon EKS cluster autoscaler.
# It specifies the IAM role and the IAM policy ARN to attach.
resource "aws_iam_role_policy_attachment" "eks_cluster_autoscaler_attach" {

  role       = aws_iam_role.eks_cluster_autoscaler.name
  policy_arn = aws_iam_policy.eks_cluster_autoscaler.arn

}