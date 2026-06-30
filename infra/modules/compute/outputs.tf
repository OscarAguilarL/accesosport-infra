output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.main.id
}

output "public_ip" {
  description = "Elastic IP fija del servidor (usar en Route 53)"
  value       = aws_eip.main.public_ip
}

output "instance_public_dns" {
  description = "DNS público para SSH inicial antes de configurar Route 53"
  value       = aws_instance.main.public_dns
}
