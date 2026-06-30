# accesosport-infra

Infraestructura de AccesoSport en AWS, gestionada con Terraform.

## ¿Qué hace este repositorio?

Provisiona y mantiene todos los recursos de AWS del proyecto:

| Módulo | Recursos |
|---|---|
| `bootstrap/` | Bucket S3 para el estado remoto de Terraform |
| `modules/networking/` | VPC, subnets públicas, Internet Gateway, Security Groups |
| `modules/compute/` | EC2 (t3.medium, Ubuntu 24.04), Elastic IP, IAM role para ECR |

## Prerequisitos

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configurado con el perfil `accesosport`
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.15

Verificar:

```bash
aws sts get-caller-identity --profile accesosport
terraform version
```

## Comandos Terraform

Todos los comandos se ejecutan desde `infra/`:

```bash
cd infra/

# Ver qué cambiará sin aplicar
terraform plan -var-file=prod.tfvars

# Aplicar cambios
terraform apply -var-file=prod.tfvars

# Ver outputs (IP pública, IDs de recursos)
terraform output
```

## Acceso al servidor EC2

El acceso es vía **SSH over SSM** — no requiere puertos abiertos ni depende del ISP. Funciona tunelizando SSH a través de HTTPS.

### Configuración (una vez por máquina)

1. Instalar el plugin de SSM:

```bash
# Manjaro / Arch
yay -S aws-session-manager-plugin

# macOS
brew install --cask session-manager-plugin
```

2. Agregar a `~/.ssh/config`:

```
Host i-* mi-*
    ProxyCommand aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p' --profile accesosport
    User ubuntu
    IdentityFile ~/.ssh/accesosport
    StrictHostKeyChecking no
```

3. Obten el ID de la instancia:

```
aws ec2 describe-instances \
  --filters "Name=tag:Project,Values=accesosport" "Name=instance-state-name,Values=running" \
  --profile accesosport \
  --query "Reservations[0].Instances[0].InstanceId" \
  --output text
```


<!-- 3. Agregar alias a `~/.zshrc`:

```bash
alias ssh-accesosport='ssh $(aws ec2 describe-instances --filters "Name=tag:Project,Values=accesosport" "Name=instance-state-name,Values=running" --profile accesosport --query "Reservations[0].Instances[0].InstanceId" --output text)'
``` -->

### Conectarse

```bash
ssh i-XXXXXXXXXXXXXXXXX
```

<!-- Guía completa: [docs/operaciones/acceso-servidor.md](../notes/docs/operaciones/acceso-servidor.md) -->
