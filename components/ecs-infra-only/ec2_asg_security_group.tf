resource "aws_security_group" "ec2_group" {
  vpc_id      = var.vpc_id
  name        = format("ECS%ASGSecurityGroup", var.cluster_name)
  description = "Allow http,https traffic"

  ingress {
    description = "allow traffic to container port from load balancer"
    from_port   = 3000
    to_port     = 3000
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
    Name = format("ECS%ASGSecurityGroup", var.cluster_name)
  })
}
