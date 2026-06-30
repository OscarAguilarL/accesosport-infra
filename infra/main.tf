module "networking" {
  source = "./modules/networking"

  project          = var.project
  environment      = var.environment
  ssh_allowed_cidr = var.ssh_allowed_cidr
}

module "compute" {
  source = "./modules/compute"

  project           = var.project
  environment       = var.environment
  subnet_id         = module.networking.public_subnet_a_id
  security_group_id = module.networking.sg_ec2_id
  public_key        = var.ec2_public_key
}
