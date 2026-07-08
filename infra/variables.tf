variable "project" {
  description = "Prefijo del proyecto para nombrar recursos"
  type        = string
  default     = "accesosport"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "ssh_allowed_cidr" {
  description = "IP o rango CIDR desde donde se permite SSH al EC2. Usar /32 para IP fija."
  type        = string
}

variable "ec2_public_key" {
  description = "Clave pública SSH para el EC2 (~/.ssh/accesosport.pub). Nunca la privada."
  type        = string
  sensitive   = true
}

variable "billing_alert_email" {
  description = "Email para recibir alertas de presupuesto de AWS"
  type        = string
}
