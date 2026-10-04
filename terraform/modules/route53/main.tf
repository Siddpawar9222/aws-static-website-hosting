# ------------------------------------------------------------------------------
# Route 53 Public Hosted Zone
# ------------------------------------------------------------------------------
resource "aws_route53_zone" "this" {
  name    = var.domain_name
  comment = "Managed by Terraform"
  tags    = var.tags
}
