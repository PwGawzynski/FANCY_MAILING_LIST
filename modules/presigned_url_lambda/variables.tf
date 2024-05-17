variable "presigned_url_lambda_name" {
  description = "Name for generating presigned url lambda"
  default = "presigned_url_generator"
}

variable "python_version" {
  description = "Python version used by lambda"
  default = "python3.12"
  type = string
}

variable "lambda_fn_path" {
  description = "Lambda handler 'path' > [filename].[fn_name]"
  default = "lambda_function.lambda_handler"
  type = string
}

variable "lambda_logging_policy_name" {
  description = "Name of polisy assigned to lamba to access logging"
  default = "presigned_url_logging_policy"
  type = string
}

variable "lambda_s3_policy_name" {
  description = "Name of polisy assigned to lamba to access logging"
  default = "s3_lambda_presigned_url_policy"
  type = string
}

variable "lambda_logging_policy_desc" {
  description = "Description for lambda logging policy"
  default = "Logging policy used to allow logging in cloudWatch"
  type = string
}
variable "lambda_s3_policy_desc" {
  description = "Description for lambda s3 policy"
  default = "Logging policy used to allow lambda perform actions with s3 usage"
  type = string
}