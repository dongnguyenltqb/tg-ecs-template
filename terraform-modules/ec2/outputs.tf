output "arns" {
  description = "The ARNs of the instance"
  value = toset([
    for instance in module.instances : instance.arn
  ])
}

output "ids" {
  description = "The IDs of the instance"
  value = toset([
    for instance in module.instances : instance.id
  ])
}

output "public_ips" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use public_ip as this field will change after the EIP is attached"
  value = toset([
    for instance in module.instances : instance.public_ip
  ])
}

output "public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value = toset([
    for instance in module.instances : instance.public_dns
  ])
}

output "private_ips" {
  description = "The private IP address assigned to the instance."
  value = toset([
    for instance in module.instances : instance.private_ip
  ])
}

output "private_dns" {
  description = "The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value = toset([
    for instance in module.instances : instance.private_dns
  ])
}
