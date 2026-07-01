module "networking" {
  source = "./modules/networking"

  project          = var.project
  environment      = var.environment
  ssh_allowed_cidr = var.ssh_allowed_cidr
}

module "compute" {
  source = "./modules/compute"

  project            = var.project
  environment        = var.environment
  subnet_id          = module.networking.public_subnet_a_id
  security_group_id  = module.networking.sg_ec2_id
  public_key         = var.ec2_public_key
  backup_bucket_name = aws_s3_bucket.db_backups.bucket
}

resource "aws_s3_bucket" "db_backups" {
  bucket = "accesosport-db-backups"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Project = var.project
    Purpose = "database-backups"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "db_backups" {
  bucket = aws_s3_bucket.db_backups.id

  rule {
    id     = "expire-old-backups"
    status = "Enabled"

    filter {}

    expiration {
      days = 30
    }
  }
}

resource "aws_s3_bucket_public_access_block" "db_backups" {
  bucket = aws_s3_bucket.db_backups.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
