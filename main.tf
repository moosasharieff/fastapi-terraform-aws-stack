
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