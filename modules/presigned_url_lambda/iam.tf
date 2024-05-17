data "aws_iam_policy_document" "presigned_url_generator_policy" {
  statement {
    actions = [ "sts:AssumeRole" ]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [ "lambda.amazonaws.com" ]
    }
  }
}

resource "aws_iam_role" "presigned_url_generator_role" {
  name = var.presigned_url_lambda_name
  assume_role_policy  = data.aws_iam_policy_document.presigned_url_generator_policy.json
}
