# This Terraform data block defines an IAM policy document for assuming an IAM role.
# It specifies the actions allowed by the policy, the effect of those actions, and the service principal allowed to assume the role.
data "aws_iam_policy_document" "assume_role_policy" {

  statement {

    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

  }

}
