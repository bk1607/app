data "aws_ami" "ami_id" {
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
  owners           = ["973714476881"]
}

#data "aws_vpc" "vpc_id" {
#  tags = {
#    Name = "main"
#  }
#}
data "aws_route53_zone" "main" {
  name = "devops2023.online"
}