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