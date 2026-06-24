module "networking" {
  source = "./modules/networking"

  project          = var.project
  environment      = var.environment
  ssh_allowed_cidr = var.ssh_allowed_cidr
}
