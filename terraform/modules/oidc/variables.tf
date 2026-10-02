variable "github_org" {
  description = "GitHub organization or username (e.g. your-github-handle)"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name (e.g. react-aws-website)"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch allowed to deploy (e.g. main or * for all branches)"
  type        = string
  default     = "main"
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket where frontend assets are deployed"
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution to invalidate"
  type        = string
}

variable "create_oidc_provider" {
  description = "Whether to create the AWS IAM OIDC provider (set to false if one already exists in your AWS account)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A mapping of tags to assign to resources"
  type        = map(string)
  default     = {}
}
