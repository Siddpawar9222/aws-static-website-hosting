# ------------------------------------------------------------------------------
# Phase 2 — Full Infrastructure Stack
#
# Prerequisites:
#   1. Phase 1 (environments/prod/dns) has been applied.
#   2. Bigrock NS records have been updated with the 4 name servers from Phase 1.
#   3. DNS propagation is complete (verify: dig NS <your-domain>).
# ------------------------------------------------------------------------------

# Look up the hosted zone created in Phase 1 — no hardcoded IDs needed
data "aws_route53_zone" "this" {
  name         = var.domain_name
  private_zone = false
}

# ------------------------------------------------------------------------------
# 1. ACM SSL/TLS Certificate with Route 53 DNS Validation (must be in us-east-1)
# ------------------------------------------------------------------------------
module "acm" {
  source = "../../../modules/acm"

  providers = {
    aws = aws.us_east_1
  }

  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  route53_zone_id           = data.aws_route53_zone.this.zone_id
  tags                      = var.tags
}

# ------------------------------------------------------------------------------
# 2. Private S3 Bucket for React Static Website
# ------------------------------------------------------------------------------
module "s3" {
  source = "../../../modules/s3"

  bucket_name                 = "${replace(var.domain_name, ".", "-")}-${var.environment}-site"
  cloudfront_distribution_arn = module.cloudfront.distribution_arn
  tags                        = var.tags
}

# ------------------------------------------------------------------------------
# 3. CloudFront CDN Distribution with OAC, SPA Routing & DNS Alias Records
# ------------------------------------------------------------------------------
module "cloudfront" {
  source = "../../../modules/cloudfront"

  domain_name                    = var.domain_name
  route53_zone_id                = data.aws_route53_zone.this.zone_id
  s3_bucket_id                   = module.s3.bucket_id
  s3_bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  acm_certificate_arn            = module.acm.certificate_arn
  tags                           = var.tags
}

# ------------------------------------------------------------------------------
# 4. AWS IAM OIDC Role for GitHub Actions CI/CD (No Static Keys)
# ------------------------------------------------------------------------------
module "oidc" {
  source = "../../../modules/oidc"

  github_org                  = var.github_org
  github_repo                 = var.github_repo
  github_branch               = var.github_branch
  s3_bucket_arn               = module.s3.bucket_arn
  cloudfront_distribution_arn = module.cloudfront.distribution_arn
  create_oidc_provider        = var.create_oidc_provider
  tags                        = var.tags
}

