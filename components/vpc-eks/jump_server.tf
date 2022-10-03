resource "aws_instance" "jump" {
  depends_on = [
    aws_security_group.jump
  ]
  ami                    = "ami-055d15d9cfddf7bd3"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.tf-1a-public.id
  vpc_security_group_ids = [aws_security_group.jump.id]
  iam_instance_profile   = var.jump_server_profile_role_name
  tags = {
    Name = format("%sJumpServer", var.cluster_name)
  }
  key_name = aws_key_pair.jump_key.key_name
  root_block_device {
    tags        = merge(local.tags, var.tags)
    volume_size = 20
    volume_type = "gp3"
  }
}
