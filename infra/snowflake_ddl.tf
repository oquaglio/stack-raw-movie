resource "snowflake_warehouse" "wh" {
  name           = var.snowflake_warehouse
  warehouse_size = var.snowflake_warehouse_size

  auto_suspend = 60
}

resource "snowflake_database" "db" {
  name                        = upper("${var.environment}")
  comment                     = upper("${var.environment} database")
  data_retention_time_in_days = 3
}

resource "snowflake_schema" "schema" {
  database = snowflake_database.db.name
  name     = "RAW_MOVIE"
  comment  = "Schema for RAW movie data"

  is_transient        = false
  is_managed          = false
  data_retention_days = 1
}

resource "snowflake_file_format" "json_file_format" {
  name              = "JSON_FILE_FORMAT"
  database          = snowflake_schema.schema.database
  schema            = snowflake_schema.schema.name
  format_type       = "JSON"
  binary_format     = "HEX"
  compression       = "AUTO"
  strip_outer_array = true
}

resource "snowflake_stage" "stage_movies" {
  name                = replace(upper("${var.stack_name}_${var.aws_region_code}_movies_load_stage_${var.environment}"), "-", "_")
  url                 = "s3://${local.bucket_name}/movies"
  database            = snowflake_schema.schema.database
  schema              = snowflake_schema.schema.name
  storage_integration = snowflake_storage_integration.integration.name
  file_format         = "format_name = ${snowflake_schema.schema.database}.${snowflake_schema.schema.name}.${snowflake_file_format.json_file_format.name}"
}
