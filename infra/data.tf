# Data source used to retrieve the AWS account ID

data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "archive_file" "movie_producer_zip" {
  type        = "zip"
  source_file = "${path.module}/../app/movie_producer.py"
  output_path = "${path.module}/files/movie_producer.py.zip"
}

data "archive_file" "movie_loader_zip" {
  type        = "zip"
  source_file = "${path.module}/../app/movie_loader.py"
  output_path = "${path.module}/files/movie_loader.py.zip"
}
