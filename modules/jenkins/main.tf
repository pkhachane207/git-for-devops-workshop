# ============================================================
# Latest Ubuntu AMI
# ============================================================

data "aws_ami" "ubuntu" {

  most_recent = true

  owners = [
    "099720109477"
  ]

  filter {

    name = "name"

    values = [
      "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
    ]
  }

  filter {

    name = "virtualization-type"

    values = [
      "hvm"
    ]
  }
}


# ============================================================
# Jenkins Launch Template
# ============================================================

resource "aws_launch_template" "jenkins" {

  name_prefix = "${var.project_name}-jenkins-"

  image_id = data.aws_ami.ubuntu.id

  instance_type = var.instance_type

  iam_instance_profile {

    name = var.jenkins_instance_profile_name
  }

  vpc_security_group_ids = [
    var.jenkins_security_group_id
  ]


  # ----------------------------------------------------------
  # Root EBS
  # ----------------------------------------------------------

  block_device_mappings {

    device_name = "/dev/sda1"

    ebs {

      volume_size = var.root_volume_size

      volume_type = "gp3"

      encrypted = true

      delete_on_termination = true
    }
  }


  # ----------------------------------------------------------
  # Jenkins installation
  # ----------------------------------------------------------

  user_data = base64encode(<<-EOF
#!/bin/bash

set -eux

export DEBIAN_FRONTEND=noninteractive

# -----------------------------------------------------------
# Update OS
# -----------------------------------------------------------

apt-get update -y


# -----------------------------------------------------------
# Install dependencies
# -----------------------------------------------------------

apt-get install -y \
  fontconfig \
  openjdk-21-jre \
  curl \
  unzip \
  nfs-common


# -----------------------------------------------------------
# Install Jenkins
# -----------------------------------------------------------

mkdir -p /etc/apt/keyrings

curl -fsSL \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
  -o /etc/apt/keyrings/jenkins-keyring.asc


echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  > /etc/apt/sources.list.d/jenkins.list


apt-get update -y

apt-get install -y jenkins


# -----------------------------------------------------------
# Stop Jenkins before EFS mount
# -----------------------------------------------------------

systemctl stop jenkins || true


# -----------------------------------------------------------
# Prepare EFS
# -----------------------------------------------------------

mkdir -p /var/lib/jenkins


# Backup original Jenkins directory if required
if [ -d /var/lib/jenkins ] && [ ! -f /var/lib/jenkins/.efs-mounted ]; then

    mkdir -p /var/lib/jenkins-local-backup

    cp -a /var/lib/jenkins/. /var/lib/jenkins-local-backup/ || true

fi


# -----------------------------------------------------------
# EFS mount
# -----------------------------------------------------------

echo "${var.efs_dns_name}:/ /var/lib/jenkins nfs4 \
nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0" \
>> /etc/fstab


mount -a


# -----------------------------------------------------------
# EFS marker
# -----------------------------------------------------------

touch /var/lib/jenkins/.efs-mounted


# -----------------------------------------------------------
# Jenkins ownership
# -----------------------------------------------------------

chown -R jenkins:jenkins /var/lib/jenkins


# -----------------------------------------------------------
# Start Jenkins
# -----------------------------------------------------------

systemctl daemon-reload

systemctl enable jenkins

systemctl start jenkins

EOF
  )


  tag_specifications {

    resource_type = "instance"

    tags = {

      Name = "${var.project_name}-jenkins"

      Role = "jenkins-controller"

      Environment = "prod"

      ManagedBy = "terraform"
    }
  }
}


# ============================================================
# Jenkins Auto Scaling Group
# ============================================================

resource "aws_autoscaling_group" "jenkins" {

  name = "${var.project_name}-jenkins-asg"

  min_size = var.min_size

  max_size = var.max_size

  desired_capacity = var.desired_capacity


  # Two AZs
  vpc_zone_identifier = var.private_subnet_ids


  launch_template {

    id = aws_launch_template.jenkins.id

    version = "$Latest"
  }


  health_check_type = "ELB"

  health_check_grace_period = 600


  # Do not terminate the Jenkins instance
  # immediately during scale-in/replacement operations.
  termination_policies = [
    "OldestLaunchTemplate",
    "OldestInstance"
  ]


  target_group_arns = [
    var.jenkins_target_group_arn
  ]


  tag {

    key = "Name"

    value = "${var.project_name}-jenkins"

    propagate_at_launch = true
  }


  tag {

    key = "Role"

    value = "jenkins-controller"

    propagate_at_launch = true
  }


  tag {

    key = "Environment"

    value = "prod"

    propagate_at_launch = true
  }
}