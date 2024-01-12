# launch template for auto scaling group
resource "aws_launch_template" "main" {
  name = "${var.name}-${var.env}"

  image_id = data.aws_ami.ami_id.id
  vpc_security_group_ids = [aws_security_group.main.id]
  instance_type = var.instance_type
  iam_instance_profile {
    name = aws_iam_instance_profile.test_profile.name
  }
  instance_market_options {
    market_type = "spot"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.name}-${var.env}"
    }
  }


  user_data = base64encode(templatefile("${path.module}/example.sh",{
    name = var.name
    env = var.env
  } ))
}

# auto scaling group resource
resource "aws_autoscaling_group" "bar" {
  name                 = "${var.name}-${var.env}"
  max_size             = var.max_size
  min_size             = var.min_size
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier = var.subnets

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

}

#security group
resource "aws_security_group" "main" {
  name        = "${var.name}-${var.env}"
  description = "${var.name}-${var.env}"
  vpc_id      = var.vpc_id

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.bastion]

  }
  ingress {
    description      = "http"
    from_port        = var.port_number
    to_port          = var.port_number
    protocol         = "tcp"
    cidr_blocks      = var.allow_app

  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.name}-${var.env}"
  }
}

