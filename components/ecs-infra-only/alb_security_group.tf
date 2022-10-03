resource "aws_security_group" "alb" {
  name        = format("ECS%sALB%sSecurityGroup", var.cluster_name)
  description = "Allow http,https traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = ""
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
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
    Name = format("ECS%sALB%sSecurityGroup", var.cluster_name)
  })
}
