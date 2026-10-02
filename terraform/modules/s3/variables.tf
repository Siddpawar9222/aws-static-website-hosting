variable "bucket_name" {
  description = "Name of the S3 bucket for hosting React static assets"
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution allowed to access this bucket"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to resources"
  type        = map(string)
  default     = {}
}
