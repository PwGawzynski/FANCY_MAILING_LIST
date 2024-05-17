resource "aws_iam_policy" "lambda_s3_full_access" {
  name        = var.lambda_s3_policy_name
  path        = "/"
  description = var.lambda_s3_policy_desc

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_s3_full_access_attachement" {
  role       = aws_iam_role.s3_lambda_listener_role.name
  policy_arn = aws_iam_policy.lambda_s3_full_access.arn
}