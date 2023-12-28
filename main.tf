# launch template for auto scaling group
resource "aws_launch_template" "main" {
  name = "main"




  image_id = data.aws_ami.ami_id.id



  instance_type = "t2.nano"




  placement {
    availability_zone = "us-east-1a"
  }



  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

  user_data = filebase64("${path.module}/example.sh")
}