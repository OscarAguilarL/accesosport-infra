variable "project" {
  description = "Prefijo del proyecto para nombrar recursos"
  type        = string
  default     = "accesosport"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "az_a" {
  type    = string
  default = "us-east-1a"
}

variable "az_b" {
  type    = string
  default = "us-east-1b"
}

variable "ssh_allowed_cidr" {
  description = "IP o rango CIDR desde donde se permite SSH al EC2. Usar /32 para IP fija."
  type        = string
  # Sin default - debe pasarse explícitamente en prod.tfvars
}
