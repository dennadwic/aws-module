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

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("/home/bhewe/.ssh/aws-key")
    host = aws_instance.jenkins.public_ip
  }

  provisioner "file" {
    source = "../bash/dependency-jenkins.sh"
    destination = "/tmp/dependency-jenkins.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/dependency-jenkins.sh",
      "cd /tmp",
      "sed -i -e 's/\r$//' dependency-jenkins.sh",
      "./dependency-jenkins.sh",
    ]
  }

  tags = {
    Name = "Jenkins"
  }
}

#Generate inventory file
resource "local_file" "inventory" {
  filename = "/home/bhewe/aws-module/ansible/inventory"
  content = <<EOF
[jenkins]
${aws_instance.jenkins.public_ip}

[jenkins:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_private_key_file=~/.ssh/aws-key.pem
ansible_user=ubuntu
  EOF

  provisioner "local-exec" {
    command = "ansible-playbook -i /home/bhewe/aws-module/ansible/inventory /home/bhewe/aws-module/ansible/jenkins/jenkins.yaml --private-key=/home/bhewe/.ssh/aws-key.pem"
  }
}
