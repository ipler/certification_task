output "server_ip" {
  description = "public ip address"
  value       = aws_instance.build[0].public_ip
}

output "sec_gr_id" {
  value = aws_security_group.allow_22_80_8080_open.id
  sensitive = false
}
