output "s3_bucket_name" {
  description = "Name of the S3 bucket where React static build files should be uploaded"
  value       = module.s3.bucket_id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3.bucket_arn
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (used in GitHub Actions for cache invalidation)"
  value       = module.cloudfront.distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFront default domain name (e.g. d1234.cloudfront.net)"
  value       = module.cloudfront.distribution_domain_name
}

output "acm_certificate_arn" {
  description = "ARN of the validated ACM SSL Certificate in us-east-1"
  value       = module.acm.certificate_arn
}

output "github_actions_role_arn" {
  description = "ARN of the IAM role for GitHub Actions OIDC authentication"
  value       = module.oidc.github_actions_role_arn
}

output "website_url" {
  description = "Public URL of the deployed React application"
  value       = "https://${var.domain_name}"
}

output "website_url_www" {
  description = "Public URL (www subdomain) of the deployed React application"
  value       = "https://www.${var.domain_name}"
}

