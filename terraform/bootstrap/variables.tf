variable "aws_region" {
  description = "AWS region to deploy backend resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
  default     = "react-aws-devops"
}

variable "state_bucket_name" {
  description = "Globally unique name for the S3 bucket used for Terraform remote state"
  type        = string
}
