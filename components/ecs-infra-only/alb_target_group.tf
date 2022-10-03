resource "aws_lb_target_group" "svc_1" {
  depends_on = [
    aws_lb.svc
  ]
  name        = format("ECS%sALBTargetGroupSvc1", var.cluster_name)
  port        = 3000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
  health_check {
    enabled  = true
    path     = "/"
    port     = 3000
    protocol = "HTTP"
    matcher  = "200,404"
  }
}
