variable "project" {
  description = "Prefijo del proyecto para nombrar recursos"
  type        = string
  default     = "accesosport"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t3.medium"
}

variable "subnet_id" {
  description = "ID de la subnet pública donde se lanza el EC2"
  type        = string
}

variable "security_group_id" {
  description = "ID del SG del EC2 (output del módulo networking)"
  type        = string
}

variable "public_key" {
  description = "Clave pública SSH (~/.ssh/accesosport.pub). Nunca la privada."
  type        = string
  sensitive   = true
}

variable "backup_bucket_name" {
  description = "Nombre del bucket S3 de backups de PostgreSQL"
  type        = string
}
