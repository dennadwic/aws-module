resource "aws_vpc" "jenkins-vpc" {
  cidr_block = var.cidr_block_vpc
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy = var.instance_tenancy

  tags = {
    Name = "jenkins-vpc"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.jenkins-vpc.id
  cidr_block = var.cidr_block_pub
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone = var.availability_zone

  tags = {
    Name = "public-subnet"
  }
}