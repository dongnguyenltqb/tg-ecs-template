resource "aws_eip" "jump" {
  vpc = true
  tags = {
    Name = format("%sJumpServerEIP", var.cluster_name)
  }
  instance = aws_instance.jump.id
}

