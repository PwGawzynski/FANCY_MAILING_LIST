module "aws_s3_bucket" {
    source = "../aws_s3_bucket"
}


data "aws_iam_policy_document" "s3_lambda_listen_policy" {
  statement {
    actions = [  "sts:AssumeRole" ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = [ "lambda.amazonaws.com" ]
    }
  }
}

resource "aws_iam_role" "s3_lambda_listener_role" {
  name = var.lambda_name
  assume_role_policy  = data.aws_iam_policy_document.s3_lambda_listen_policy.json
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 14
}


resource "aws_iam_policy" "ses_lambda_full_access" {
  name        = "ses_lambda_full_access"
  path        = "/"
  description = "IAM policy for "

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


resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
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

resource "aws_iam_policy" "lambda_s3_full_access" {
  name        = "lambda_s3_full_access"
  path        = "/"
  description = "IAM policy for access to s3"

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

resource "aws_iam_role_policy_attachment" "lambda_ses_full_access_atachement" {
  role       = aws_iam_role.s3_lambda_listener_role.name
  policy_arn = aws_iam_policy.ses_lambda_full_access.arn
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.s3_lambda_listener_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role_policy_attachment" "lambda_s3_full_access_attachement" {
  role       = aws_iam_role.s3_lambda_listener_role.name
  policy_arn = aws_iam_policy.lambda_s3_full_access.arn
}

data "archive_file" "zip_lambda_files" {
  type = "zip"
  source_dir = "${path.module}/s3_lambda_listener"
  output_path = "${path.module}/s3_lambda_listener/s3_lambda_listener.zip"
}

resource "aws_lambda_function" "s3_lambda_listener_function" {
  filename = "${path.module}/s3_lambda_listener/s3_lambda_listener.zip"
  function_name = var.lambda_name
  role = aws_iam_role.s3_lambda_listener_role.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"
  depends_on = [ aws_iam_role_policy_attachment.lambda_logs ]
}

resource "aws_lambda_permission" "allow_lambda_put_post" {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_lambda_listener_function.function_name
  principal = "s3.amazonaws.com"
  source_arn = "arn:aws:s3:::${module.aws_s3_bucket.mailing_list_bucket.id}"
}


resource "aws_s3_bucket_notification" "on_put_trigger_lambda" {
  bucket = module.aws_s3_bucket.mailing_list_bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_lambda_listener_function.arn
    events = [ "s3:ObjectCreated:Put", "s3:ObjectCreated:Post" ]
  }
   depends_on      = [aws_lambda_permission.allow_lambda_put_post]
}

