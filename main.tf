provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr_block
}

module "security_group" {
  source         = "./modules/security-group"
  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = var.vpc_cidr_block
}


module "iam" {
  source         = "./modules/iam"
  s3_bucket_name = var.aws_s3_bucket_name
}

module "ec2" {
  source                = "./modules/ec2"
  instance_type         = "t3.micro"
  region                = "ap-southeast-1"
  web_server_sg_id      = module.security_group.web_server_sg_id
  subnet_id             = module.vpc.public_subnet_id
  instance_profile_name = module.iam.instance_profile_name
}


module "rds" {
  source            = "./modules/rds"
  private_a_subnet_id = module.vpc.private_a_subnet_id
  private_b_subnet_id = module.vpc.private_b_subnet_id
  rds_sg_id         = module.security_group.rds_sg_id
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}