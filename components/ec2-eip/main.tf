resource "aws_instance" "this" {
  ami                         = var.ami != null ? var.ami : data.aws_ami.amazon-linux-2.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.this.id]
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = true
  tags = merge(var.tags, {
    Name = var.name != null ? var.name : "${var.project}Instance"
  })
  key_name  = aws_key_pair.this.key_name
  user_data = var.user_data != null ? var.user_data : file("./default_user_data.sh")
  root_block_device {
    tags = merge(var.tags, {
      Name = var.name != null ? var.name : "${var.project}InstanceEBSVolume"
    })
    volume_size = 10
    volume_type = "gp3"
  }
}

resource "aws_security_group" "this" {
  name        = "${var.project}EC2SecurityGroup"
  description = "Allow http, ssh traffic from internet"
  vpc_id      = var.vpc_id
  tags = merge(var.tags, {
    Name = var.name != null ? var.name : "${var.project}InstanceSecurityGroup"
  })

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group_rule" "this" {
  count                    = length(var.allow_rules)
  type                     = "ingress"
  from_port                = var.allow_rules[count.index].port
  to_port                  = var.allow_rules[count.index].port
  protocol                 = "tcp"
  cidr_blocks              = var.allow_rules[count.index].cidr_block
  source_security_group_id = var.allow_rules[count.index].source_security_group_id
  security_group_id        = aws_security_group.this.id
}

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_eip" "this" {
  count = var.use_eip == true ? 1 : 0
  depends_on = [
    aws_instance.this
  ]
  vpc = true
}

resource "aws_eip_association" "this" {
  count = var.use_eip == true ? 1 : 0
  depends_on = [
    aws_eip.this,
    aws_instance.this
  ]
  instance_id   = aws_instance.this.id
  allocation_id = aws_eip.this[0].id
}

resource "aws_lb_target_group_attachment" "this" {
  depends_on = [
    aws_instance.this
  ]
  count            = length(var.target_groups)
  target_group_arn = var.target_groups[count.index].target_group_arn
  target_id        = aws_instance.this.id
  port             = var.target_groups[count.index].port
}
