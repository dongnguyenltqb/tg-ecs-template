resource "aws_security_group" "svc" {
  name        = "ecsServiceSg"
  description = "Allow http,https traffic"
  vpc_id      = var.vpc_id

  ingress {
    description     = "allow fe port"
    from_port       = var.fe_container_port
    to_port         = var.fe_container_port
    protocol        = "TCP"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description     = "allow be port"
    from_port       = var.be_container_port
    to_port         = var.be_container_port
    protocol        = "TCP"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "alb" {
  name        = "ecsServiceALBSg"
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
}
resource "aws_security_group" "ec2_group" {
  name        = "ecsEc2GroupSg"
  description = "Allow http,https traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "allow traffic to container port from load balancer"
    from_port   = var.fe_container_port
    to_port     = var.fe_container_port
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow traffic to container port from load balancer"
    from_port   = var.be_container_port
    to_port     = var.be_container_port
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
}
