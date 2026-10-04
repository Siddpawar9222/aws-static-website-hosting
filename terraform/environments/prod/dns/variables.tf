variable "aws_region" {
  description = "AWS region"
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

