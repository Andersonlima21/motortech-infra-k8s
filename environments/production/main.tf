terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "motortech"
      Environment = "production"
      ManagedBy   = "terraform"
    }
  }
}

module "vpc" {
  source      = "../../modules/vpc"
  project     = var.project
  environment = "production"
}

module "security_groups" {
  source  = "../../modules/security-groups"
  project = var.project
  vpc_id  = module.vpc.vpc_id
}

module "ecr" {
  source      = "../../modules/ecr"
  project     = var.project
  environment = "production"
}

module "eks" {
  source             = "../../modules/eks"
  project            = var.project
  environment        = "production"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  node_instance_types = ["t3.medium"]
  capacity_type       = "ON_DEMAND"
  node_desired_size   = 2
  node_min_size       = 2
  node_max_size       = 5
}
