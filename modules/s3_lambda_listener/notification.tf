
resource "aws_s3_bucket_notification" "on_put_trigger_lambda" {
  bucket = module.shared_bucket.bucket_id
  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_lambda_listener_function.arn
    events = [ "s3:ObjectCreated:Put", "s3:ObjectCreated:Post" ]
    filter_prefix = module.shared_bucket.mailing_lists_folder_name
    filter_suffix = var.mailing_list_suffix
  }
   depends_on  = [aws_lambda_permission.allow_lambda_put_post]
}
