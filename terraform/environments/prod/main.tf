# ------------------------------------------------------------------------------
# 1. Route 53 Public Hosted Zone & DNS Records
# ------------------------------------------------------------------------------
module "route53" {
  source = "../../modules/route53"

  domain_name               = var.domain_name
  cloudfront_domain_name    = module.cloudfront.distribution_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.distribution_hosted_zone_id
  create_records            = true
  tags                      = var.tags
}

# ------------------------------------------------------------------------------
# 2. ACM SSL/TLS Certificate with Route 53 DNS Validation (Must be in us-east-1)
# ------------------------------------------------------------------------------
module "acm" {
  source = "../../modules/acm"

  providers = {
    aws = aws.us_east_1
  }

  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  route53_zone_id           = module.route53.zone_id
  tags                      = var.tags
}

# ------------------------------------------------------------------------------
# 3. Private S3 Bucket for React Static Website
# ------------------------------------------------------------------------------
module "s3" {
  source = "../../modules/s3"

  # S3 bucket names must be lowercase, alphanumeric and dashes only
  bucket_name                 = "${replace(var.domain_name, ".", "-")}-${var.environment}-site"
  cloudfront_distribution_arn = module.cloudfront.distribution_arn
  tags                        = var.tags
}

# ------------------------------------------------------------------------------
# 4. CloudFront CDN Distribution with OAC and SPA Custom Error Responses
# ------------------------------------------------------------------------------
module "cloudfront" {
  source = "../../modules/cloudfront"

  domain_name                    = var.domain_name
  s3_bucket_id                   = module.s3.bucket_id
  s3_bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  acm_certificate_arn            = module.acm.certificate_arn
  tags                           = var.tags
}

# ------------------------------------------------------------------------------
# 5. AWS IAM OIDC Role for GitHub Actions CI/CD (No Static Keys)
# ------------------------------------------------------------------------------
module "oidc" {
  source = "../../modules/oidc"

  github_org                  = var.github_org
  github_repo                 = var.github_repo
  github_branch               = var.github_branch
  s3_bucket_arn               = module.s3.bucket_arn
  cloudfront_distribution_arn = module.cloudfront.distribution_arn
  create_oidc_provider        = var.create_oidc_provider
  tags                        = var.tags
}
