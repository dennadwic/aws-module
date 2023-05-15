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

resource "aws_instance" "webserver" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = var.aws_instance
  key_name                = var.key_name
  vpc_security_group_ids  = var.security_group
  subnet_id               = var.staging_public_subnet

  root_block_device {
    volume_size = "10"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("/home/bhewe/.ssh/aws-key")
    host = aws_instance.webserver.public_ip
  }

  tags = {
    Name = "${var.name}"
  }
}

resource "time_sleep" "wait_90_seconds" {
  depends_on = [aws_instance.webserver]
  create_duration = "90s"
}

#Generate inventory file
resource "local_file" "inventory" {
  filename = "/home/bhewe/aws-module/ansible/inventory"
  content = <<EOF
[webserver]
${aws_instance.webserver.public_ip}

[webserver:vars]
domain=duniaku.com
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_private_key_file=~/.ssh/aws-key.pem
ansible_user=ubuntu
  EOF

  provisioner "local-exec" {
    command = "ansible-playbook -i /home/bhewe/aws-module/ansible/inventory /home/bhewe/aws-module/ansible/nginx/nginx.yaml --private-key=/home/bhewe/.ssh/aws-key.pem"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i /home/bhewe/aws-module/ansible/inventory /home/bhewe/aws-module/ansible/nginx/sync.yaml --private-key=/home/bhewe/.ssh/aws-key.pem"
  }

  depends_on = [time_sleep.wait_90_seconds]
}
