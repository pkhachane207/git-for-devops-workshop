resource "aws_efs_file_system" "jenkins" {

  creation_token = "${var.project_name}-jenkins-efs-dr"

  encrypted = true

  performance_mode = "generalPurpose"

  throughput_mode = "elastic"

  tags = {
    Name = "${var.project_name}-jenkins-efs"
  }
}


resource "aws_efs_mount_target" "jenkins" {

  count = length(var.private_subnet_ids)

  file_system_id = aws_efs_file_system.jenkins.id

  subnet_id = var.private_subnet_ids[count.index]

  security_groups = [
    var.efs_security_group_id
  ]
}