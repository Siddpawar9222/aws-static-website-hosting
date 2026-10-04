# ------------------------------------------------------------------------------
# Phase 1 — DNS Bootstrap
#
# Run this FIRST. After apply, copy the name_servers output into Bigrock
# as the NS records for your domain. Wait ~15–30 min for propagation,
# then run Phase 2 (environments/prod/infra).
# ------------------------------------------------------------------------------
module "route53" {
  source = "../../../modules/route53"

  domain_name = var.domain_name
  tags = {
    Phase = "dns"
  }
}

