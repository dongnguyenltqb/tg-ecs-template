resource "aws_lb" "svc" {
  name                       = "app"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb.id]
  subnets                    = var.subnets
  enable_deletion_protection = false
}


// front end target group
resource "aws_lb_target_group" "fe" {
  name        = format("%s-fe-target-group", aws_lb.svc.name)
  port        = var.fe_container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

// back end target group
resource "aws_lb_target_group" "be" {
  depends_on = [
    aws_lb.svc
  ]
  name        = format("%s-be-target-group", aws_lb.svc.name)
  port        = var.be_container_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
  health_check {
    enabled  = true
    path     = "/"
    port     = var.be_container_port
    protocol = "HTTP"
  }
}


// listener response 403 by default
resource "aws_lb_listener" "http" {
  port              = "80"
  load_balancer_arn = aws_lb.svc.arn
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = 403
      message_body = ""
    }
  }
}

# resource "aws_lb_listener_rule" "fe" {
#   listener_arn = aws_lb_listener.http.arn
#   priority     = 2
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.fe.arn
#   }
#   condition {
#     path_pattern {
#       values = ["/"]
#     }
#   }
# }

resource "aws_lb_listener_rule" "be" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.be.arn
  }
  condition {
    path_pattern {
      values = ["/api"]
    }
  }
}

