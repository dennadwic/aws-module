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
  shared_credentials_files = ["/home/bhewe/.aws/credentials"]
  profile                  = "default"
}

locals {
  ssh_user          = "ubuntu"
  key_name          = "aws-key"
  private_key_path  = "/home/bhewe/.ssh/aws-key"
}

module "development-vpc" {
  source = "../../modules/vpc"

  vpc_name = "development-vpc"
  cidr_block_vpc = "192.1.0.0/16"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  instance_tenancy = "default"

  cidr_block_pub = "192.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-southeast-3a"
}

module "development-network" {
  source = "../../modules/network/development"

  name = "jenkins"
  development_vpc = module.development-vpc.development_vpc
  cidr_block_public_RT = "0.0.0.0/0"
  development_public_subnet = module.development-vpc.development_public_subnet
  connectivity_type_nat = "public"
}

module "jenkins" {
  source = "../../modules/ec2/development/jenkins"

  name = "jenkins"
  aws_instance = "t3.micro"
  development_public_subnet = module.development-vpc.development_public_subnet
  security_group = [module.development-network.security_group]
}