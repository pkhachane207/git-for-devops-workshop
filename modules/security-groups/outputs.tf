output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "jenkins_sg_id" {
  value = aws_security_group.jenkins.id
}

output "efs_sg_id" {
  value = aws_security_group.efs.id
}