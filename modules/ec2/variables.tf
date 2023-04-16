variable "key_name" {
  type     = string
  default  = "aws-key"
}

variable "aws_instance" {
  type = string
}

variable "jenkins_security_group" {
  type = list(string)
}

variable "jenkins_public_subnet" {
  type = string
}