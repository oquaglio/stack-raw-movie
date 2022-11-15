#--------------------------------------------------------------
# Global Config
#--------------------------------------------------------------

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "s3_bucket_name" {
  description = "Name of bucket"
  value       = module.s3_bucket.s3_bucket_id
}

output "lambda_role_arn" {
  description = "Lambda Role ARN"
  value       = aws_iam_role.lambda_role.arn
}

output "movie_loader_lambda_func" {
  description = "Lambda Role ARN"
  value       = aws_lambda_function.movie_loader_lambda_func.arn
}

output "movie_producer_lambda_func" {
  description = "Lambda Role ARN"
  value       = aws_lambda_function.movie_producer_lambda_func.arn
}

output "json_file_format" {
  description = "Snowflake JSON FILE FORMAT OBJECT"
  value       = snowflake_file_format.json_file_format.name
}
