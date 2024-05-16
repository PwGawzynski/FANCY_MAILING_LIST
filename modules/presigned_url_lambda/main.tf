module "shared_bucket" {
    source = "../aws_s3_bucket"
}

data "aws_iam_policy_document" "presigned_url_generator_policy" {
  statement {
    actions = [ "sts:AssumeRole" ]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [ "lambda.amazonaws.com" ]
    }
  }
}

resource "aws_iam_role" "presigned_url_generator_role" {
  name = var.presigned_url_lambda_name
  assume_role_policy  = data.aws_iam_policy_document.presigned_url_generator_policy.json
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.presigned_url_lambda_name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "logging_policy" {
  name        = "logging_policy"
  path        = "/"
  description = "IAM policy for logging from a lambda"

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

resource "aws_iam_policy" "s3_lambda_presigned_url_policy" {
  name = "s3_lambda_presigned_url_policy"
  path = "/"
  description = "Lambda acces to s3 policy"
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

data "archive_file" "zip_lambda_files" {
  type = "zip"
  source_dir = "${path.module}/lambda_code"
  output_path = "${path.module}/lambda_code/lambda_code.zip"
}

resource "aws_lambda_function" "presigned_url_generator_function" {
  filename = "${path.module}/lambda_code/lambda_code.zip"
  function_name = var.presigned_url_lambda_name
  role = aws_iam_role.presigned_url_generator_role.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"
  source_code_hash = filebase64sha256("${path.module}/lambda_code/lambda_code.zip")
  depends_on = [ aws_iam_role_policy_attachment.lambda_logs ]
}

resource "aws_lambda_function_url" "public_url" {
  function_name      = aws_lambda_function.presigned_url_generator_function.function_name
  authorization_type = "NONE"
}

