provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "server" {
  ami                    = "ami-0aba19e56f3eaec05"
  instance_type          = "t3.micro"
  availability_zone      = "eu-north-1a"
  vpc_security_group_ids = ["sg-09fee9dd698eff420"]
  key_name               = "terraform-practice-key"

  tags = {
    Name = "terraform-ansible-auto"
  }

  provisioner "local-exec" {
    command = <<EOT
sleep 30
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${self.public_ip},' -u ubuntu --private-key /root/terraform-ec2-practice/terraform-practice-key.pem playbook.yml
EOT
  }
}

output "public_ip" {
  value = aws_instance.server.public_ip
}
