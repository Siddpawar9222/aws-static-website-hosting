variable "aws_region" {
  description = "Primary AWS region for regional resources"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Project name prefix for AWS resources"
  type        = string
  default     = "react-aws-website"
}

variable "domain_name" {
  description = "Apex domain name registered in Bigrock (e.g. example.com)"
  type        = string
}

variable "github_org" {
  description = "GitHub username or organization name"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "github_branch" {
  description = "Allowed GitHub branch for deployments"
  type        = string
  default     = "main"
}

variable "create_oidc_provider" {
  description = "Set to false if the GitHub OIDC provider already exists in this AWS account"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to merge with default resource tags"
  type        = map(string)
  default     = {}
}

