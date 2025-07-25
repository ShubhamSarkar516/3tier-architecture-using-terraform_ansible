terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.myregion
}

# Generate Key Pair
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "tf-key-pair" {
  key_name   = "Mafia"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "tf-key" {
  content         = tls_private_key.rsa.private_key_pem
  filename        = "Mafia"
  file_permission = "0400"
}

# Modules
module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source    = "./modules/vpc"
  alb_sg_id = module.security.alb_sg_id
}

module "bastion" {
  source        = "./modules/bastion"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  vpc_sg_id     = module.security.bastion_sg_id
  subnet_id     = module.vpc.public_subnet_ids[0] # One public subnet
  key_name      = var.key_name
}

module "web" {
  source            = "./modules/web"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  vpc_sg_id         = module.security.web_sg_id
  subnet_ids        = module.vpc.public_subnet_ids  # List for 2 AZs
  target_group_arn  = module.vpc.target_group_arn
  key_name          = aws_key_pair.tf-key-pair.key_name
}

module "app" {
  source        = "./modules/app"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  vpc_sg_id     = module.security.app_sg_id
  subnet_ids    = module.vpc.private_subnet_ids
  key_name      = aws_key_pair.tf-key-pair.key_name
}

module "db" {
  source         = "./modules/rds"
  vpc_sg_id      = module.security.db_sg_id
  dbsubnet_group = module.vpc.dbsubnet_group
  username       = var.username
  password       = var.password
}

# Local Ansible .env file for DB credentials
resource "local_file" "db_env_file" {
  content  = <<EOT
#!/bin/bash

# Database Details
export DB_HOST=${split(":", module.db.db_endpoint)[0]}
export DB_PORT=3306
export DB_USER=${var.username}
export DB_PASS=${var.password}
export DB_NAME=facebook

# Web Tier
export WEB_HOST_1=${module.web.web_instance_private_ips[0]}
export WEB_HOST_2=${module.web.web_instance_private_ips[1]}

# App Tier
export APP_HOST_1=${module.app.app_instance_private_ips[0]}
export APP_HOST_2=${module.app.app_instance_private_ips[1]}
EOT

  filename = "${path.module}/ansible/db_env.sh"
  file_permission = "0644"
}

