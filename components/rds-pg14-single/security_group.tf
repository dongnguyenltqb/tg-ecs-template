resource "aws_security_group" "this" {
  name        = format("%sRdsInstanceSG", var.name)
  description = format("this sg is for rds instance: %s", var.name)
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow all internal connection"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.tags, var.tags, {
    Name = format("%sRdsInstanceSG", var.name)
  })
}
