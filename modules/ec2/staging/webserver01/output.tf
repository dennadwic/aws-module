output "ip_public" {
  value = aws_instance.webserver.public_ip
}