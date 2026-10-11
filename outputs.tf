output "vpc_id" {
  value = module.vpc.vpc_id
}

output "jenkins_asg_name" {
  value = module.jenkins.autoscaling_group_name
}

output "jenkins_launch_template_id" {
  value = module.jenkins.launch_template_id
}

output "jenkins_efs_id" {
  value = module.efs.efs_id
}

output "jenkins_alb_dns_name" {
  value = module.alb.alb_dns_name
}