data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
  key_name = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

}

resource "null_resource" "cluster" {
  triggers = {
    always_run = "${timestamp()}"
  }

  connection {
    host = element(aws_instance.web.*.public_ip, 0)
    type = "ssh"
    user = "ubuntu"
    private_key = file("~/.ssh/id_rsa") 
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install apache2 -y"
      
    ]
  }
}
