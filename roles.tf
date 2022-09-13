resource "aws_iam_role" "lambda_assume_role" {
  name = "lambda-assume-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "lambda-assume-role"
  }
}

#----------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "s3_access_for_lambda" {
  statement {
    sid = "LambdaAccessS3Bucket"
    actions = [
      "s3:ListBucket",
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.word_count_bucket.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.word_count_bucket.bucket}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_access_lambda" {
  name = "s3_access_for_lambda"
  description = "Allow Lambda function to access S3 bucket and objects"
  policy = data.aws_iam_policy_document.s3_access_for_lambda.json
}

resource "aws_iam_role_policy_attachment" "lambda_access_s3" {
  role = aws_iam_role.lambda_assume_role.name
  policy_arn = aws_iam_policy.s3_access_lambda.arn
}

#---------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "sns_access_for_lambda" {
  statement {
    sid = "LambdaAccessSNS"
    actions = ["sns:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "sns_access_lambda" {
  name = "sns_access_for_lambda"
  description = "Allow Lambda function to send message to SNS topic"
  policy = data.aws_iam_policy_document.sns_access_for_lambda.json
}

resource "aws_iam_role_policy_attachment" "lambda_access_sns" {
  role = aws_iam_role.lambda_assume_role.name
  policy_arn = aws_iam_policy.sns_access_lambda.arn
}

#---------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "cw_access_for_lambda" {
  statement {
    sid = "LambdaAccessCW"
    actions = [
        "autoscaling:Describe*",
        "cloudwatch:*",
        "logs:*",
        "sns:*",
        "iam:GetPolicy",
        "iam:GetPolicyVersion",
        "iam:GetRole"
    ]
    resources = ["*"]
  }
  statement {
    sid = "LambdaAccessCWEvents"
    actions = [
        "iam:CreateServiceLinkedRole"
    ]
    resources = [
        "arn:aws:iam::*:role/aws-service-role/events.amazonaws.com/AWSServiceRoleForCloudWatchEvents*"
    ]
    condition {
      test     = "StringLike"
      variable = "iam:AWSServiceName"
      values   = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "cw_access_lambda" {
  name = "cw_access_for_lambda"
  description = "Allow Lambda function to send logs to Cloudwatch"
  policy = data.aws_iam_policy_document.cw_access_for_lambda.json
}

resource "aws_iam_role_policy_attachment" "lambda_access_cw" {
  role = aws_iam_role.lambda_assume_role.name
  policy_arn = aws_iam_policy.cw_access_lambda.arn
}

#----------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "lambda_basic_execution" {
  statement {
    sid = "LambdaBasicExecutionRole"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_basic_exec" {
  name = "lambda_basic_execution_role"
  description = "Basic execution role for lambda"
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_exec_role" {
  role = aws_iam_role.lambda_assume_role.name
  policy_arn = aws_iam_policy.lambda_basic_exec.arn
}