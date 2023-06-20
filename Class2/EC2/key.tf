resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key11"
  public_key = file("~/.ssh/id_rsa.pub")


  tags = local.common_tags
}



output ec2_ip {
    value = aws_instance.web.public_ip
}