output "github_actions_role_arn" {
  description = "ARN of the IAM role for GitHub Actions to assume via OIDC"
  value       = aws_iam_role.github_actions_frontend.arn
}

output "oidc_provider_arn" {
  description = "ARN of the IAM OIDC provider for GitHub"
  value       = local.oidc_provider_arn
}
