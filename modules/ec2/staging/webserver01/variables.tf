variable "key_name" {
  type     = string
  default  = "aws-key"
}

variable "aws_instance" {
  type = string
}

variable "security_group" {
  type = list(string)
}

variable "staging_public_subnet" {
  type = string
}

variable "name" {
  type = string
}