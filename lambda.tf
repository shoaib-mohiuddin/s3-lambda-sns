# Archive a single file.

data "archive_file" "python_script_file" {
  type        = "zip"
  source_file = "${path.module}/python-scripts/${var.lambda_function_name}.py"
  output_path = "${path.module}/files/lambda-function.zip"
}

resource "aws_lambda_function" "lambda_word_count" {
  # If the file is not in the current working directory you will need to include a 
  # path.module in the filename.
  filename      = data.archive_file.python_script_file.output_path
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_assume_role.arn
  handler       = "${var.lambda_function_name}.lambda_handler"

  source_code_hash = filebase64sha256(data.archive_file.python_script_file.output_path)

  runtime = "python3.8"
  timeout = 7

  # environment {
  #   variables = {
  #     "METADATA_TABLE" = aws_dynamodb_table.lambda_image_rekognition.name
  #   }
  # }
}