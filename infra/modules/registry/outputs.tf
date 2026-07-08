output "backend_repository_url" {
  description = "URL del repositorio ECR del backend"
  value       = aws_ecr_repository.backend.repository_url
}

output "frontend_repository_url" {
  description = "URL del repositorio ECR del frontend"
  value       = aws_ecr_repository.frontend.repository_url
}
