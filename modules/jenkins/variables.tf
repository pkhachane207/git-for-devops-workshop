variable "project_name" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "jenkins_security_group_id" {
  type = string
}

variable "jenkins_target_group_arn" {
  type = string
}

variable "jenkins_instance_profile_name" {
  type = string
}

variable "efs_id" {
  type = string
}

variable "efs_dns_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "root_volume_size" {
  type = number
}