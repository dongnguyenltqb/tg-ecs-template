# security group for application load balancer
resource "aws_security_group" "main" {
  name        = "${var.project}-alb-sg"
  description = "allow incoming HTTP traffic only"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      protocol    = "tcp"
      from_port   = ingress.value
      to_port     = ingress.value
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-alb-sg"
    Application = var.project
    Environment = var.env
  }
}

# using ALB - instances in private subnets
resource "aws_alb" "main" {
  enable_deletion_protection = true
  name                       = "${var.project}-alb"
  security_groups            = [aws_security_group.main.id]
  subnets                    = var.subnets
  idle_timeout               = var.alb_idle_timeout
  tags = {
    Name        = "${var.project}-alb"
    Application = var.project
    Environment = var.env
  }
}

# listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_alb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_alb_listener" "https_listener" {
  depends_on = [aws_acm_certificate.main, aws_alb_target_group.main]

  load_balancer_arn = aws_alb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.main.arn

  default_action {
    //    target_group_arn = aws_alb_target_group.main.arn
    type = "forward"
    forward {
      dynamic "target_group" {
        for_each = aws_alb_target_group.main
        content {
          arn = target_group.value.arn
        }
      }
    }
  }
}
# alb target group
//resource "aws_alb_target_group" "main" {
//  name     = "${var.project}-alb-targetgroup"
//  port     = 80
//  protocol = "HTTP"
//  vpc_id   = var.vpc_id
//  health_check {
//    interval = var.health_check.interval
//    path = var.health_check.endpoint
//    port = 80
//  }
//}

resource "aws_alb_target_group" "main" {
  for_each = var.target_groups
  name     = "${var.project}-${each.key}"
  port     = lookup(each.value, "port", 80)
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    interval = try(each.value.health_check.interval, 60)
    path     = try(each.value.health_check.endpoint, "/")
    port     = lookup(each.value, "port", 80)
  }
}
