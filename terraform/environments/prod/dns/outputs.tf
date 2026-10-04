output "zone_id" {
  description = "Route 53 Hosted Zone ID — pass this to infra if needed"
  value       = module.route53.zone_id
}

output "name_servers" {
  description = <<-EOT
    ============================================================
    ACTION REQUIRED — Update Bigrock NS Records
    ============================================================
    Log into Bigrock → DNS Management → select your domain →
    change the 4 NS records to these values, then wait
    15–30 minutes for propagation before running Phase 2.
    ============================================================
  EOT
  value       = module.route53.name_servers
}

