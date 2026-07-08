data "aws_caller_identity" "current" {}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

resource "aws_iam_role" "github_actions" {
  name = "${var.project}-github-actions"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github_actions.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        "ForAnyValue:StringLike" = {
          "token.actions.githubusercontent.com:sub" = [
            "repo:OscarAguilarL/accesosport-core:*",
            "repo:OscarAguilarL/accesosport-backoffice-app_v2:*"
          ]
        }
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "github_actions_ecr" {
  name = "ecr-push"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Resource = [
          "arn:aws:ecr:us-east-1:${data.aws_caller_identity.current.account_id}:repository/${var.project}-backend",
          "arn:aws:ecr:us-east-1:${data.aws_caller_identity.current.account_id}:repository/${var.project}-frontend"
        ]
      }
    ]
  })
}

resource "aws_security_group_rule" "ssh_cicd" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "SSH para GitHub Actions CI/CD"
  security_group_id = module.networking.sg_ec2_id
}

output "github_actions_role_arn" {
  description = "ARN del rol IAM — agregar como secret AWS_ROLE_ARN en cada repo de GitHub"
  value       = aws_iam_role.github_actions.arn
}

output "elastic_ip" {
  description = "Elastic IP del EC2 — usar como EC2_HOST en GitHub Secrets"
  value       = module.compute.public_ip
}
