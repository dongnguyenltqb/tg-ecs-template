# How to use

## Get the existing AMI

```terraform
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}
```

## Create a new security group with suitable rules

```terraform
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = local.name
  description = "Security group for example usage with EC2 instance"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]

  tags = local.tags
}
```

## Provision the ec2 instances

```terraform
module "ec2_multiple" {
  source = "../../terraform-modules/ec2"

  for_each = local.multiple_instances

  name = "${local.name}-multi-${each.key}"

  ami = data.aws_ami.amazon_linux.id
  instance_type = each.value.instance_type
  availability_zone = each.value.availability_zone
  subnet_id = each.value.subnet_id
  vpc_security_group_ids = [
    module.security_group.security_group_id]

  enable_volume_tags = false
  root_block_device = lookup(each.value, "root_block_device", [])

  tags = local.tags
}
```
