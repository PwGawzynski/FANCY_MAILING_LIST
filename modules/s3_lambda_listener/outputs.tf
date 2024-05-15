output "terraform_aws_role_output" {
  value = aws_iam_role.s3_lambda_listener_role
}
output "aws_iam_role_arn_output" {
  value = aws_lambda_function.s3_lambda_listener_function.arn
}

output "terraform_logging_policy_arn_output" {
  value = aws_iam_policy.lambda_logging.arn
}