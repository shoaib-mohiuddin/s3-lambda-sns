resource "aws_sns_topic" "word_count_topic" {
  name = "word-count-topic"
}

resource "aws_sns_topic_subscription" "wc_topic_sub" {
  topic_arn = aws_sns_topic.word_count_topic.arn
  protocol  = "email"
  endpoint  = "shoaibmm7@gmail.com"
}