output "vpc_id" {
  description = "ID de la VPC principal"
  value       = aws_vpc.main.id
}

output "public_subnet_a_id" {
  value = aws_subnet.public_a.id
}

output "public_subnet_b_id" {
  value = aws_subnet.public_b.id
}

output "sg_ec2_id" {
  description = "ID del Security Group del EC2 (usar en compute module)"
  value       = aws_security_group.ec2.id
}
