data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.aws_instance
  key_name      = var.key_name
  vpc_security_group_ids = var.jenkins_security_group
  subnet_id     = var.jenkins_public_subnet


  root_block_device {
    volume_size = "10"
  }

  tags = {
    Name = "Jenkins"
  }
}