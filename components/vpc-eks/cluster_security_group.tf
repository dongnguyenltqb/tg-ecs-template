resource "aws_security_group" "cluster" {
  depends_on = [
    aws_security_group.jump
  ]
  name        = format("%sEKSClusterSg", var.cluster_name)
  description = "Security group for cluster"
  vpc_id      = aws_vpc.tf-vpc.id

  // allow all traffic from jump server
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.jump.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
