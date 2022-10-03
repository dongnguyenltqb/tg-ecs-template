resource "aws_key_pair" "jump_key" {
  key_name   = format("%sJumpKey", var.cluster_name)
  public_key = var.jump_pubkey
}
