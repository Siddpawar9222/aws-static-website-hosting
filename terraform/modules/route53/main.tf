# ------------------------------------------------------------------------------
# Route 53 Public Hosted Zone
# ------------------------------------------------------------------------------
resource "aws_route53_zone" "this" {
  name    = var.domain_name
  comment = "Managed by Terraform for React Website"
  tags    = var.tags
}

# ------------------------------------------------------------------------------
# Apex Domain (example.com) -> CloudFront Alias (IPv4 & IPv6)
# ------------------------------------------------------------------------------
resource "aws_route53_record" "apex_a" {
  count   = var.create_records && var.cloudfront_domain_name != "" ? 1 : 0
  zone_id = aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "apex_aaaa" {
  count   = var.create_records && var.cloudfront_domain_name != "" ? 1 : 0
  zone_id = aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "AAAA"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

# ------------------------------------------------------------------------------
# Subdomain (www.example.com) -> CloudFront Alias (IPv4 & IPv6)
# ------------------------------------------------------------------------------
resource "aws_route53_record" "www_a" {
  count   = var.create_records && var.cloudfront_domain_name != "" ? 1 : 0
  zone_id = aws_route53_zone.this.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_aaaa" {
  count   = var.create_records && var.cloudfront_domain_name != "" ? 1 : 0
  zone_id = aws_route53_zone.this.zone_id
  name    = "www.${var.domain_name}"
  type    = "AAAA"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}
