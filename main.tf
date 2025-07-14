
module "ssm" {
  source = "./modules/ssm"

  project = var.project
}

module "ec2-key" {
  source = "./modules/ec2-key"

  project = var.project
}

module "vpc" {
  source = "./modules/vpc"

  project = var.project
}

module "ec2" {
  source = "./modules/ec2"

  project = var.project

  # Passing outputs into ec2 module
  vpc_id = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  private_key_pem = module.ec2-key.private_key_pem
}