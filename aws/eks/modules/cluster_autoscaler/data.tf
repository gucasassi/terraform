# This Terraform data block retrieves a TLS certificate from the specified URL.
# It is using the "tls_certificate" data source provided by the Terraform TLS provider.
data "tls_certificate" "eks" {
  url = var.cluster_issuer
}

# This Terraform data block defines an IAM policy document for the EKS cluster autoscaler's assume role policy.
# It allows the cluster autoscaler to assume an IAM role using Web Identity Federation.
data "aws_iam_policy_document" "eks_cluster_autoscaler_assume_role_policy" {

  statement {

    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    # This condition ensures that only requests from the Kubernetes service account "cluster-autoscaler"
    # are allowed to assume the IAM role associated with the EKS cluster.
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }

    # This specifies that the principal allowed to assume the IAM role is the OIDC provider associated with the EKS cluster.
    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }

  }

}

# This Terraform data block defines an IAM policy document for the Amazon EKS cluster autoscaler.
# It specifies the actions allowed by the policy, the effect of those actions, and any conditions that must be met.
data "aws_iam_policy_document" "eks_cluster_autoscaler" {

  statement {

    actions = [
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeAutoScalingGroups",
      "ec2:DescribeLaunchTemplateVersions",
      "autoscaling:DescribeTags",
      "autoscaling:DescribeLaunchConfigurations",
      "ec2:DescribeInstanceTypes",
    ]

    effect    = "Allow"
    resources = ["*"]

  }

  statement {

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
    ]

    effect    = "Allow"
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/${var.cluster_name}"
      values   = ["owned"]
    }

  }

}
