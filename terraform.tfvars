aws_region  = "ap-south-1"
environment = "prod"

project_name = "jenkins"

vpc_cidr = "11.0.0.0/16"

availability_zones = [
  "ap-south-1a",
  "ap-south-1b"
]

public_subnet_cidrs = [
  "11.0.1.0/24",
  "11.0.2.0/24"
]

private_subnet_cidrs = [
  "11.0.11.0/24",
  "11.0.12.0/24"
]

jenkins_instance_type = "t2.medium"

# One Jenkins controller only.
# ASG is for replacement/recovery, not multiple controllers.

jenkins_min_size         = 1
jenkins_max_size         = 1
jenkins_desired_capacity = 1

jenkins_root_volume_size = 100
