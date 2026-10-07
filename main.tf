# ============================================================
# VPC
# ============================================================

module "vpc" {

  source = "../modules/vpc"

  project_name = var.project_name

  vpc_cidr = var.vpc_cidr

  availability_zones = var.availability_zones

  public_subnet_cidrs = var.public_subnet_cidrs

  private_subnet_cidrs = var.private_subnet_cidrs
}


# ============================================================
# Security Groups
# ============================================================

module "security_groups" {

  source = "../modules/security-groups"

  project_name = var.project_name

  vpc_id = module.vpc.vpc_id

  vpc_cidr = var.vpc_cidr
}


# ============================================================
# IAM
# ============================================================

module "iam" {

  source = "../modules/iam"

  project_name = var.project_name
}


# ============================================================
# EFS
# ============================================================

module "efs" {

  source = "../modules/efs"

  project_name = var.project_name

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  efs_security_group_id = module.security_groups.efs_sg_id
}


# ============================================================
# ALB
# ============================================================

module "alb" {

  source = "../modules/alb"

  project_name = var.project_name

  vpc_id = module.vpc.vpc_id

  public_subnet_ids = module.vpc.public_subnet_ids

  alb_security_group_id = module.security_groups.alb_sg_id

  jenkins_security_group_id = module.security_groups.jenkins_sg_id
}


# ============================================================
# Jenkins
# ============================================================

module "jenkins" {

  source = "../modules/jenkins"

  project_name = var.project_name

  private_subnet_ids = module.vpc.private_subnet_ids

  jenkins_security_group_id = module.security_groups.jenkins_sg_id

  jenkins_target_group_arn = module.alb.target_group_arn

  jenkins_instance_profile_name = module.iam.jenkins_instance_profile_name

  efs_id = module.efs.efs_id

  efs_dns_name = module.efs.efs_dns_name

  instance_type = var.jenkins_instance_type

  min_size = var.jenkins_min_size

  max_size = var.jenkins_max_size

  desired_capacity = var.jenkins_desired_capacity

  root_volume_size = var.jenkins_root_volume_size
}