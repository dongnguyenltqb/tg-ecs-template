data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["OpenVPN Access Server Community Image*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["444663524611"]
}
