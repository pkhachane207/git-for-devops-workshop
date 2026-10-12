resource "aws_security_group" "alb" {

  name = "${var.project_name}-alb-sg"

  vpc_id = var.vpc_id

  ingress {

    description = "HTTP"

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {

    description = "HTTPS"

    from_port = 443
    to_port   = 443

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

resource "aws_security_group" "jenkins" {

  name = "${var.project_name}-jenkins-sg"

  vpc_id = var.vpc_id

  # Jenkins UI only from ALB
  ingress {

    description = "Jenkins from ALB"

    from_port = 8080
    to_port   = 8080

    protocol = "tcp"

    security_groups = [
      aws_security_group.alb.id
    ]
  }

  # SSH is intentionally NOT open to the internet.
  # Use AWS SSM Session Manager.

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.project_name}-jenkins-sg"
  }
}

resource "aws_security_group" "efs" {

  name = "${var.project_name}-efs-sg"

  vpc_id = var.vpc_id

  ingress {

    description = "NFS from Jenkins"

    from_port = 2049
    to_port   = 2049

    protocol = "tcp"

    security_groups = [
      aws_security_group.jenkins.id
    ]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.project_name}-efs-sg"
  }
}

