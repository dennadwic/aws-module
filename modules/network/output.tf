output "jenkins_security_group" {
  value = aws_security_group.ssh-allowed.id
}