terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
  }
}

# ------------------------------------------------------------------------------
# Fetch GitHub Actions OIDC TLS Certificate Thumbprint dynamically
# ------------------------------------------------------------------------------
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

# ------------------------------------------------------------------------------
# IAM OpenID Connect Provider for GitHub Actions (Account-wide)
# ------------------------------------------------------------------------------
resource "aws_iam_openid_connect_provider" "github" {
  count = var.create_oidc_provider ? 1 : 0

  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]

  tags = var.tags
}

locals {
  # Use created provider ARN or construct ARN if provider already existed
  oidc_provider_arn = var.create_oidc_provider ? aws_iam_openid_connect_provider.github[0].arn : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"

  # Condition string: allow specific branch or wildcard in repo
  repo_sub_condition = var.github_branch == "*" ? "repo:${var.github_org}/${var.github_repo}:*" : "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/${var.github_branch}"
}

data "aws_caller_identity" "current" {}

# ------------------------------------------------------------------------------
# IAM Trust Policy for GitHub Actions (AssumeRoleWithWebIdentity)
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "github_actions_trust_policy" {
  statement {
    sid     = "GitHubActionsOIDC"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [local.repo_sub_condition]
    }
  }
}

# ------------------------------------------------------------------------------
# IAM Role for GitHub Actions Frontend Deployment
# ------------------------------------------------------------------------------
resource "aws_iam_role" "github_actions_frontend" {
  name               = "github-actions-frontend-deploy"
  description        = "IAM role assumed by GitHub Actions via OIDC to deploy React frontend to S3 and CloudFront"
  assume_role_policy = data.aws_iam_policy_document.github_actions_trust_policy.json

  tags = var.tags
}

# ------------------------------------------------------------------------------
# Least-Privilege IAM Policy for Frontend Deployment
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "frontend_deploy_policy" {
  # S3 bucket permissions
  statement {
    sid    = "S3ListBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [var.s3_bucket_arn]
  }

  statement {
    sid    = "S3SyncObjects"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl"
    ]
    resources = ["${var.s3_bucket_arn}/*"]
  }

  # CloudFront Invalidation permissions
  statement {
    sid    = "CloudFrontCreateInvalidation"
    effect = "Allow"
    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation",
      "cloudfront:ListInvalidations"
    ]
    resources = [var.cloudfront_distribution_arn]
  }
}

resource "aws_iam_role_policy" "frontend_deploy" {
  name   = "frontend-deployment-policy"
  role   = aws_iam_role.github_actions_frontend.id
  policy = data.aws_iam_policy_document.frontend_deploy_policy.json
}
