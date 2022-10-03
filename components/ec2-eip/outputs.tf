output "public_ip" {
  value = var.use_eip == true ? aws_eip.this[0].public_ip : aws_instance.this.public_ip
}

output "security_group" {
  value = aws_security_group.this.id
}

output "instance-id" {
  value = aws_instance.this.id
}
