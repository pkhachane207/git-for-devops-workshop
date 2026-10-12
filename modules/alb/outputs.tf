output "target_group_arn" {

  value = aws_lb_target_group.jenkins.arn
}


output "alb_dns_name" {

  value = aws_lb.jenkins.dns_name
}