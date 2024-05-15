output "aws_s3_bucket" {
  description = "S3 Module Outputs"
  value       = module.aws_s3_bucket
}
output "s3_lambda_listener" {
  description = "S3 Lambda listener module outputs"
  value = module.s3_lambda_listener
}
output "presigned_url_lambda" {
  description = "Lambda for creating presigned url"
  value = module.presigned_url_lambda
}