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

output "snowflake_pipes" {
  value = snowflake_pipe.snowflake_pipes
}

output "aws_s3_bucket_notification" {
  value = aws_s3_bucket_notification.new_objects_notification
}

output "tables" {
  value = local.tables[*].name
}

output "number_of_tables" {
  value = length(local.tables)
}

resource "null_resource" "tables" {
  for_each = { for tbl in local.tables : tbl.name => tbl }

  triggers = {
    name = each.value.name
  }
}

output "table_fields" {
  value = local.tables[*].fields[*].name
}

output "bucket_key_prefixes" {
  value = local.bucket_key_prefixes_for_tables
}

output "movie_key_prefix" {
  value = lookup(local.bucket_key_prefixes_for_tables, "MOVIE", "default")
}

output "table_fields_2" {
  value = local.table_fields
}

output "snowflake_tables" {
  value = snowflake_table.snowflake_tables[*]
}

output "primary_keys" {
  value = snowflake_table_constraint.primary_keys
}

output "pipe_copy_stmts" {
  value = local.pipes[index(local.pipes.*.table, "MOVIE2")].copy_stmt
}

output "copy_stmts_for_actor_table" {
  value = local.pipes[index(local.pipes.*.table, "ACTOR")].copy_stmt
}

output "snowflake_tables2" {
  value = [for tbl in snowflake_table.snowflake_tables : tbl]
}

output "snowflake_table_names" {
  value = [for tbl in snowflake_table.snowflake_tables : tbl.name]
}

output "movie2_attrs" {
  value = local.tables[index(local.tables.*.name, "MOVIE2")]
}

output "movie2_pk" {
  value = lookup(local.tables[index(local.tables.*.name, "MOVIE2")], "primary_key")
}

output "genre_pk" {
  value = [for tbl in local.tables : try(lookup(local.tables[index(local.tables.*.name, tbl.name)], "primary_key", false))]
}

output "pipes" {
  value = [for pipe in local.pipes : pipe.name]
}

output "pipe_copy_statements" {
  value = [for pipe in local.pipes : local.pipes[index(local.pipes.*.name, pipe.name)].copy_stmt]
}
