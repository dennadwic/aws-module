output "webserver_ip_public" {
  value = module.webserver.ip_public
}

# output "jenkins_vpc" {
#   value = module.main.jenkins_vpc
# }

# output "jenkins_public_subnet" {
#   value =  module.main.jenkins_public_subnet
# }

# output "jenkins_security_group" {
#   value = module.jenkins-network.jenkins_security_group
# }

# output "jenkins_ec2_ip_public" {
#   value = module.jenkins-ec2.ip_public
# }