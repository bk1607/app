data "aws_ami" "ami_id" {
  most_recent      = true
  name_regex       = "ansible-ami"
  owners           = ["self"]
}

data "aws_vpc" "vpc_id" {
  tags = {
    Name = "main"
  }
}
