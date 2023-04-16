output "jenkins_vpc" {
  value = module.jenkins-vpc.jenkins_vpc
}

output "jenkins_public_subnet" {
  value =  module.jenkins-vpc.jenkins_public_subnet
}

output "jenkins_security_group" {
  value = module.jenkins-network.jenkins_security_group
}

output "jenkins_ec2_ip_public" {
  value = module.jenkins-ec2.ip_public
}