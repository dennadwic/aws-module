output "jenkins_vpc" {
  value = aws_vpc.jenkins-vpc.id
}

output "jenkins_public_subnet" {
  value = aws_subnet.public-subnet.id
}