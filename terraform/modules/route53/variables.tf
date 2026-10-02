variable "domain_name" {
  description = "Apex domain name (e.g. example.com)"
  type        = string
}

variable "cloudfront_domain_name" {
  description = "CloudFront distribution domain name (e.g. d1234abcd.cloudfront.net)"
  type        = string
  default     = ""
}

variable "cloudfront_hosted_zone_id" {
  description = "CloudFront Route 53 Hosted Zone ID (always Z2FDTNDATAQYW2)"
  type        = string
  default     = "Z2FDTNDATAQYW2"
}

variable "create_records" {
  description = "Whether to create DNS A/AAAA alias records pointing to CloudFront (set to true once CloudFront is configured)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A mapping of tags to assign to resources"
  type        = map(string)
  default     = {}
}
