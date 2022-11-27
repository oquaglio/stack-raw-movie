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

resource "aws_lambda_function" "movie_loader_lambda_func" {
  filename      = "${path.module}/files/movie_loader.py.zip"
  function_name = "${var.stack_name}-movie-loader-lambda-function-${var.environment}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "movie_loader.lambda_handler"
  runtime       = "python3.9"
  depends_on    = [aws_iam_role_policy_attachment.lambda_policy_attachment]
  tags          = local.tags
}

resource "aws_lambda_function" "movie_producer_lambda_func" {
  filename      = "${path.module}/files/movie_producer.py.zip"
  function_name = "${var.stack_name}-movie-producer-lambda-function-${var.environment}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "movie_producer.lambda_handler"
  runtime       = "python3.9"
  timeout       = "300"
  depends_on    = [aws_iam_role_policy_attachment.lambda_policy_attachment]
  tags          = local.tags
}
