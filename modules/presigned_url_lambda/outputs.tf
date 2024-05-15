output "labda_public_url" {
  description = "Public lambda address"
  value = aws_lambda_function_url.public_url.function_url
}