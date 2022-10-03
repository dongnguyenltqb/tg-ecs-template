resource "aws_lb" "this" {
  name                       = var.nlb_name
  internal                   = false
  load_balancer_type         = "network"
  subnets                    = var.nlb_subnets
  enable_deletion_protection = false
  tags                       = var.tags
}

resource "aws_lb_listener" "https" {
  depends_on = [
    aws_lb_target_group.this
  ]
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  certificate_arn   = var.nlb_cert_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.plaintext.arn
  }
}

resource "aws_security_group" "this" {
  name        = "${var.nlb_name}SecurityGroup"
  description = "Allow http, ssh traffic from internet"
  vpc_id      = var.vpc_id
  tags        = var.tags
  ingress     = []
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_lb_target_group" "this" {
  name        = "${var.nlb_name}BackEndTG"
  target_type = "instance"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  health_check {
    interval            = 10
    protocol            = "HTTP"
    port                = 80
    enabled             = true
    path                = "/healcheck404"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "plaintext" {
  name        = "${var.nlb_name}ForwarderTG"
  target_type = "instance"
  port        = 8888
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  health_check {
    interval            = 10
    protocol            = "HTTP"
    port                = 8888
    enabled             = true
    path                = "/healthcheck"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}
