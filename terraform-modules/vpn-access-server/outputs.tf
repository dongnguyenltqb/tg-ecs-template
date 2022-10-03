output "security_group_id" {
  value = aws_security_group.this.id
}

output "vpn_access_server_ip" {
  value = aws_eip.this.public_ip
}
output "vpn_access_server_url" {
  value = format("https://%s/admin:943", aws_eip.this.public_ip)
}
