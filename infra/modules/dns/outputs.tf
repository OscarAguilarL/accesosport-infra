output "nameservers" {
  description = "Nameservers de Route 53 — pegar en Namecheap → Custom DNS"
  value       = aws_route53_zone.main.name_servers
}

output "zone_id" {
  value = aws_route53_zone.main.zone_id
}
