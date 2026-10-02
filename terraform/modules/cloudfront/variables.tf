variable "domain_name" {
  description = "Apex domain name for CloudFront aliases"
  type        = string
}

variable "s3_bucket_id" {
  description = "Name/ID of the S3 bucket origin"
  type        = string
}

variable "s3_bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket origin"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of the validated ACM certificate in us-east-1"
  type        = string
}

variable "price_class" {
  description = "CloudFront distribution price class (e.g. PriceClass_100, PriceClass_200, PriceClass_All)"
  type        = string
  default     = "PriceClass_100" # Lowest cost: US, Canada, Europe
}

variable "tags" {
  description = "A mapping of tags to assign to resources"
  type        = map(string)
  default     = {}
}
