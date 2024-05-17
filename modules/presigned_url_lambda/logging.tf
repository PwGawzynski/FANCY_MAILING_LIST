resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.presigned_url_lambda_name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "logging_policy" {
  name        = var.lambda_logging_policy_name
  path        = "/"
  description = var.lambda_logging_policy_desc

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.presigned_url_generator_role.name
  policy_arn = aws_iam_policy.logging_policy.arn
}