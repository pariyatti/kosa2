locals {
  name   = "kosa2-iam-github-oidc"
  region = "us-east-1"

  tags = {
    Project    = local.name
    GithubRepo = "kosa2"
    GithubOrg  = "pariyatti"
  }
}

module "iam_github_oidc_provider" {
  source = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"

  tags = local.tags
}

################################################################################
# GitHub OIDC Role
################################################################################

module "iam_github_oidc_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"

  name = local.name

  subjects = [
    "repo:pariyatti/kosa2:pull_request",
    "pariyatti/kosa2:ref:refs/heads/main",
  ]

  policies = {
    sessionsmanager = aws_iam_policy.ssm_session_manager_policy.arn
  }

  tags = local.tags
}

resource "aws_iam_policy" "ssm_session_manager_policy" {
  name        = "SSMSessionManagerPolicy"
  description = "IAM policy for Systems Manager Session Manager"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ssm:CreateAssociation",
          "ssm:DescribeAssociation",
          "ssm:GetDocument",
          "ssm:ListAssociations",
          "ssm:UpdateAssociationStatus",
          "ssm:CreateDocument",
          "ssm:DeleteDocument",
          "ssm:DescribeDocument",
          "ssm:DescribeInstanceInformation",
          "ssm:CreateSession",
          "ssm:TerminateSession",
          "ssm:SendCommand",
          "ec2:Describe*"
        ],
        Resource = "*",
      },
    ],
  })
}
