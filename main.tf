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
  target_group_arns = [aws_lb_target_group.main.arn]

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

# to create a target group
resource "aws_lb_target_group" "main" {
  name     = "${var.name}-${var.env}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    enabled = true
    healthy_threshold = 2
    unhealthy_threshold = 5
    interval = 5
    timeout = 4
  }
}

# to create route53 record
resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = local.dns_name
  type    = "CNAME"
  ttl     = 300
  records = [var.lb_dns_name]
}

# to create rules in listener
#resource "aws_lb_listener_rule" "main" {
#  listener_arn = var.listener_arn
#  priority     = var.priority
#
#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.main.arn
#  }
#
#  condition {
#    host_header {
#      values = [local.dns_name]
#    }
#  }
#}