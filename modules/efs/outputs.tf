output "efs_id" {

  value = aws_efs_file_system.jenkins.id
}


output "efs_dns_name" {

  value = aws_efs_file_system.jenkins.dns_name
}