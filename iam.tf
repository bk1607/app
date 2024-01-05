# creating iam policy to get ssm parameters
resource "aws_iam_policy" "main" {
  name        = "${var.name}-${var.env}-policy"
  path        = "/"
  description = "parameters policy"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters",
                "ssm:GetParameter"
            ],
            "Resource": "arn:aws:ssm:us-east-1:046657053850:parameter/${var.name}-${var.env}"
        }
    ]
})
}

#creating iam role
resource "aws_iam_role" "main" {
  name = "${var.name}-${var.env}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "main-attach" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.arn
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "${var.name}-${var.env}-instance-profile"
  role = aws_iam_role.main.name
}
