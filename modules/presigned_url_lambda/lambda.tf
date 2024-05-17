module "shared_bucket" {
    source = "../aws_s3_bucket"
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
  handler = var.lambda_fn_path
  runtime = var.python_version
  source_code_hash = filebase64sha256("${path.module}/lambda_code/lambda_code.zip")
  depends_on = [ aws_iam_role_policy_attachment.lambda_logs ]
  environment {
    variables = {
      BUCKET_NAME = module.shared_bucket.bucket_id
      FOLDER_NAME = module.shared_bucket.mailing_lists_folder_name
    }
  }
}

resource "aws_lambda_function_url" "public_url" {
  function_name      = aws_lambda_function.presigned_url_generator_function.function_name
  authorization_type = "NONE"
}

