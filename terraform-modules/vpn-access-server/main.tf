// VPN access server
resource "aws_instance" "this" {
  depends_on = [
    aws_security_group.this
  ]
  ami                         = data.aws_ami.ubuntu.id
  user_data                   = <<-EOF
              admin_user=${var.admin_user}
              admin_pw=${var.admin_password}
              EOF
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.this.id]
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  tags = merge(var.tags, {
    Name = format("%s-OpenVPNAccessServerEC2Instance", var.project)
  })
}

// Static IP for VPN Server
resource "aws_eip" "this" {
  vpc      = true
  instance = aws_instance.this.id
  depends_on = [
    aws_instance.this
  ]
  tags = merge(var.tags, {
    Name = format("%s-OpenVPNAccessServerElasticIP", var.project)
  })
}
// Security group for VPN access server
resource "aws_security_group" "this" {
  name        = format("%s-OpenVPNAccessServerSecurityGroup", var.project)
  description = "Security group for VPN access server"
  vpc_id      = var.vpc_id
  tags_all = merge(var.tags, {
    Name = format("%s-OpenVPNAccessServerSecurityGroupRule", var.project)
  })
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 943
    to_port     = 943
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "udp"
    from_port   = 1194
    to_port     = 1194
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
