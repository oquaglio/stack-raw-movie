#--------------------------------------------------------------
# Global Config
#--------------------------------------------------------------

output "workspace" {
  value = terraform.workspace
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_s3_bucket_id" {
  value = aws_s3_bucket.stage_bucket_load.id
}

output "aws_s3_bucket_arn" {
  value = aws_s3_bucket.stage_bucket_load.arn
}

output "aws_sns_topic_arn" {
  value = aws_sns_topic.snowflake_load_bucket_topic.arn
}

output "lambda_role_arn" {
  description = "Lambda Role ARN"
  value       = aws_iam_role.lambda_role.arn
}

output "movie_loader_lambda_func" {
  description = "Lambda Function ARN"
  value       = aws_lambda_function.movie_loader_lambda_func.arn
}

output "movie_producer_lambda_func" {
  description = "Lambda Role ARN"
  value       = aws_lambda_function.movie_producer_lambda_func.arn
}

# output "snowflake_role_arn" {
#   value = aws_iam_role.role_for_snowflake_load.arn
# }

# output "snowflake_storage_integration_id" {
#   value = snowflake_storage_integration.integration.id
# }

# output "storage_aws_external_id" {
#   value = snowflake_storage_integration.integration.storage_aws_external_id
# }

# output "storage_aws_iam_user_arn" {
#   value = snowflake_storage_integration.integration.storage_aws_iam_user_arn
#}

output "snowflake_load_trust_policy_template" {
  value = data.template_file.snowflake_load_trust_policy_template.rendered
}

output "snowflake_storage_integration_id" {
  value = snowflake_storage_integration.integration.id
}

output "snowflake_storage_aws_external_id" {
  value = snowflake_storage_integration.integration.storage_aws_external_id
}

output "snowflake_storage_aws_iam_user_arn" {
  value = snowflake_storage_integration.integration.storage_aws_iam_user_arn
}

output "snowflake_db" {
  value = snowflake_database.db.name
}

output "snowflake_schema" {
  value = snowflake_schema.schema.name
}

output "snowflake_stage_movies" {
  value = snowflake_stage.stage_movies.name
}

output "snowflake_stage_integration" {
  value = snowflake_stage.stage_movies.storage_integration
}

output "snowflake_table" {
  value = snowflake_table.movie.name
}

output "snowflake_pipe_name" {
  value = snowflake_pipe.pipe_movies.name
}

output "snowflake_pipe" {
  value = snowflake_pipe.pipe_movies
}

output "aws_s3_bucket_notification" {
  value = aws_s3_bucket_notification.new_objects_notification
}
