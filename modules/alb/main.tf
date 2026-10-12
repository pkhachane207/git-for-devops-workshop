resource "aws_lb" "jenkins" {

  name = "${var.project_name}-alb"

  load_balancer_type = "application"

  internal = false

  security_groups = [
    var.alb_security_group_id
  ]

  subnets = var.public_subnet_ids

  tags = {
    Name = "${var.project_name}-alb"
  }
}


resource "aws_lb_target_group" "jenkins" {

  name = "${var.project_name}-tg"

  port = 8080

  protocol = "HTTP"

  vpc_id = var.vpc_id

  target_type = "instance"

  health_check {

    enabled = true

    path = "/login"

    port = "8080"

    protocol = "HTTP"

    healthy_threshold = 3

    unhealthy_threshold = 3

    timeout = 5

    interval = 30
  }

  tags = {
    Name = "${var.project_name}-jenkins-tg"
  }
}


resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.jenkins.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.jenkins.arn
  }
}