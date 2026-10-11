variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "jenkins_instance_type" {
  type = string
}

variable "jenkins_min_size" {
  type = number
}

variable "jenkins_max_size" {
  type = number
}

variable "jenkins_desired_capacity" {
  type = number
}

variable "jenkins_root_volume_size" {
  type = number
}

variable "jenkins_domain_name" {
  type    = string
  default = ""
}