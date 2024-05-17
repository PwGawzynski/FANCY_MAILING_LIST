variable "lambda_name" {
  description = "s3_lambda_listener_name"
  default = "s3_lambda_listener"
  type = string
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
  description = "Name of policy assigned to lamba to access logging"
  default = "s3_listener_logging_policy"
  type = string
}

variable "lambda_s3_policy_name" {
  description = "Name of policy assigned to lamba to access s3"
  default = "lambda_s3_full_access"
  type = string
}

variable "lambda_ses_policy_name" {
  description = "Name of policy assigned to lamba to access ses"
  default = "ses_lambda_full_access"
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

variable "lambda_ses_policy_desc" {
  description = "Description for lambda ses policy"
  default = "Logging policy used to allow lambda perform actions sith ses usage"
  type = string
}

variable "mailing_list_suffix" {
  description = "Served file extensions"
  default = ".json"
  type = string
}

variable "sender_mail" {
  description = "Email address which will be used as mail:from in any send mail from mailing list"
  default = "kontakt@pwgawzynski.pl"
  type = string
}