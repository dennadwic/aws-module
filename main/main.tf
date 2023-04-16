terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.63.0"
    }
  }
}

provider "aws" {
  region                   = "ap-southeast-3"
  shared_credentials_files = ["D:/StudiDevOps/AWS/.aws/credentials"]
  profile                  = "default"
}

locals {
  ssh_user          = "ubuntu"
  key_name          = "aws-key"
  private_key_path  = "D:/StudiDevOps/AWS/SSH/aws-key"
}

module "jenkins-vpc" {
  source = "../modules/vpc"

  vpc_name = "jenkins-vpc"
  cidr_block_vpc = "192.1.0.0/16"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  instance_tenancy = "default"

  cidr_block_pub = "192.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-southeast-3a"
}

module "jenkins-network" {
  source = "../modules/network"

  jenkins_vpc = module.jenkins-vpc.jenkins_vpc
  cidr_block_public_RT = "0.0.0.0/0"
  jenkins_public_subnet = module.jenkins-vpc.jenkins_public_subnet
  connectivity_type_jenkins_nat = "public"
}

module "jenkins-ec2" {
  source = "../modules/ec2"

  aws_instance = "t3.micro"
  jenkins_public_subnet = module.jenkins-vpc.jenkins_public_subnet
  jenkins_security_group = [module.jenkins-network.jenkins_security_group]
}