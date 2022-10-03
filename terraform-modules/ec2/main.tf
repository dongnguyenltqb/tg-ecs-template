module "instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = var.instances

  ami                    = var.ami
  name                   = "${var.name}-multi-${each.key}"
  instance_type          = each.value.instance_type
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = var.security_group_ids

  enable_volume_tags     = false
  root_block_device      = each.value.root_block_device

  iam_instance_profile   = var.iam_instance_profile
  user_data              = var.user_data
  monitoring             = var.enable_monitoring
  key_name               = var.ssh_key_name

  tags = var.tags
}
