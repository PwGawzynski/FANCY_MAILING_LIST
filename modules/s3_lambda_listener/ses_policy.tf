resource "aws_iam_policy" "ses_lambda_full_access" {
  name        = var.lambda_ses_policy_name
  path        = "/"
  description = var.lambda_ses_policy_desc

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ses:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_ses_full_access_atachement" {
  role       = aws_iam_role.s3_lambda_listener_role.name
  policy_arn = aws_iam_policy.ses_lambda_full_access.arn
}