resource "aws_security_group" "this" {
  name        = format("ECS%sService%sSecurityGroup", var.cluster_name, var.service_name)
  description = "Allow http,https traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "allow be port"
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags_all = merge(local.tags, var.tags, {
    Name = format("ECS%sService%sSecurityGroup", var.cluster_name, var.service_name)
  })
}
