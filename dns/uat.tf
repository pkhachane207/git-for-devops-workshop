resource "aws_instance" "secins" {
    instance_type = var.instance_type
    ami = var.ami_id
    subnet_id = var.subnet_id
}