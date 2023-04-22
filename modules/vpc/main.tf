resource "aws_vpc" "main" {
  cidr_block = var.cidr_block_vpc
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy = var.instance_tenancy

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_pub
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone = var.availability_zone

  tags = {
    Name = "public-subnet-${var.vpc_name}"
  }
}