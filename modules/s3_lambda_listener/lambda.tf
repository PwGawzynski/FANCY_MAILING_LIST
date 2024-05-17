module "shared_bucket" {
    source = "../aws_s3_bucket"
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
  handler = var.lambda_fn_path
  runtime = var.python_version
  source_code_hash = filebase64sha256("${path.module}/s3_lambda_listener/s3_lambda_listener.zip")
  depends_on = [ aws_iam_role_policy_attachment.lambda_logs ]
  environment {
    variables = {
      BUCKET_NAME = module.shared_bucket.bucket_id
      SENDER_MAIL = var.sender_mail
    }
  }
}

resource "aws_lambda_permission" "allow_lambda_put_post" {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_lambda_listener_function.function_name
  principal = "s3.amazonaws.com"
  source_arn = "arn:aws:s3:::${module.shared_bucket.bucket_id}"
}


