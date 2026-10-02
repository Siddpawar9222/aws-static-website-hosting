output "zone_id" {
  description = "The Hosted Zone ID in Route 53"
  value       = aws_route53_zone.this.zone_id
}

output "zone_name" {
  description = "The Hosted Zone Name"
  value       = aws_route53_zone.this.name
}

output "name_servers" {
  description = "The 4 authoritative Name Servers to update in BigRock DNS settings"
  value       = aws_route53_zone.this.name_servers
}
