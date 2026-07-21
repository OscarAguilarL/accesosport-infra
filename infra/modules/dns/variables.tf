variable "project" {
  type = string
}

variable "ec2_public_ip" {
  type        = string
  description = "Elastic IP del servidor EC2 (output del módulo compute)"
}
