resource "aws_iam_policy" "s3_lambda_presigned_url_policy" {
  name = var.lambda_s3_policy_name
  path = "/"
  description = var.lambda_logging_policy_desc
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListObjects",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:PutObject"
            ],
            "Resource": "${module.shared_bucket.bucket_arn}/*"
        }
    ]
}
  EOF
}

resource "aws_iam_role_policy_attachment" "presigned_url_generator_policy_attachement" {
  role       = aws_iam_role.presigned_url_generator_role.name
  policy_arn = aws_iam_policy.s3_lambda_presigned_url_policy.arn
}