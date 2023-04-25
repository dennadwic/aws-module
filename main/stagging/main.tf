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

module "staging-vpc" {
  source = "../../modules/vpc"

  vpc_name = "staging-vpc"
  cidr_block_vpc = "192.2.0.0/16"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  instance_tenancy = "default"

  cidr_block_pub = "192.2.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-southeast-3a"
}

module "staging-network" {
  source = "../../modules/network/staging"

  name = "webserver"
  staging_vpc = module.staging-vpc.staging_vpc
  cidr_block_public_RT = "0.0.0.0/0"
  staging_public_subnet = module.staging-vpc.staging_public_subnet
  connectivity_type_nat = "public"
}

module "webserver" {
  source = "../../modules/ec2/staging/webserver01"

  name = "webserver"
  aws_instance = "t3.micro"
  staging_public_subnet = module.staging-vpc.staging_public_subnet
  security_group = [module.staging-network.security_group]
}
