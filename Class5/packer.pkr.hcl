packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "example" {
  ami_name      = "golden-image {{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami = "ami-022e1a32d3f742bd8"
  ssh_username = "ec2-user"
  ssh_keypair_name = "packer"
  ssh_private_key_file = "~/.ssh/id_rsa"

  ami_users = [
     ""        # provide AWS account number
  ]

  ami_regions = [
    "us-east-1",
    "us-east-2"
  ]

  run_tags = {
    Name = "Golden Image"
  }
}

build {
  sources = ["source.amazon-ebs.example"]

  provisioner "shell" {
    script = "setup.sh"
  }

  provisioner "breakpoint" {
    note = "Please verify"
  }
}



