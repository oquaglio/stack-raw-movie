resource "aws_s3_bucket_notification" "new_objects_notification" {
  bucket = aws_s3_bucket.stage_bucket_load.id

  topic {
    topic_arn = aws_sns_topic.snowflake_load_bucket_topic.arn
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_s3_bucket.stage_bucket_load, aws_sns_topic.snowflake_load_bucket_topic]
}
