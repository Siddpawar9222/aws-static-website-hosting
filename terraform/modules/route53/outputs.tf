output "zone_id" {
  description = "The Route 53 Hosted Zone ID"
  value       = aws_route53_zone.this.zone_id
}

output "name_servers" {
  description = "The 4 NS records to enter in Bigrock before running Phase 2 (infra)"
  value       = aws_route53_zone.this.name_servers
}
