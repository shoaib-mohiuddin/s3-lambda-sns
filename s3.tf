resource "aws_s3_bucket" "word_count_bucket" {
  bucket = "word-count-smm-bucket"

  tags = {
    Name        = "word-count-smm-bucket"
    Environment = "Test"
  }
}

resource "aws_s3_bucket_notification" "event_notification" {
  bucket = aws_s3_bucket.word_count_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_word_count.arn
    events              = ["s3:ObjectCreated:*"]
    # filter_prefix       = "AWSLogs/"
    # filter_suffix       = ".log"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}