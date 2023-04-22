resource "aws_internet_gateway" "jenkins-igw" {
  vpc_id = var.jenkins_vpc
  tags = {
    Name = "jenkins-igw"
  }
}

resource "aws_route_table" "public-RT" {
  vpc_id = var.jenkins_vpc

  route {
    cidr_block = var.cidr_block_public_RT
    gateway_id = aws_internet_gateway.jenkins-igw.id
  }

  tags = {
    Name = "public-RT"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = var.jenkins_public_subnet
  route_table_id = aws_route_table.public-RT.id
}

resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "jenkins-nat" {
  connectivity_type = var.connectivity_type_jenkins_nat
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = var.jenkins_public_subnet

  tags = {
    Name = "jenkins-nat"
  }
}

resource "aws_security_group" "ssh-allowed" {
  vpc_id = var.jenkins_vpc

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  tags = {
    Name = "jenkins-firewall"
  }
}
