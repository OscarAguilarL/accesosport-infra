output "state_bucket_name" {
  description = "Nombre del bucket S3 para el estado de Terraform"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "state_bucket_arn" {
  description = "ARN del bucket S3 (usar en políticas IAM)"
  value       = aws_s3_bucket.terraform_state.arn
}
