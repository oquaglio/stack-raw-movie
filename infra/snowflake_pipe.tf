resource "snowflake_pipe" "pipe_movies" {
  database = snowflake_schema.schema.database
  schema   = snowflake_schema.schema.name
  name     = replace(upper("${var.stack_name}_${var.aws_region_code}_movies_pipe"), "-", "_")
  comment  = "A pipe to ingest the incoming movies."

  copy_statement = <<EOT
    COPY INTO ${snowflake_table.movie.database}.${snowflake_table.movie.schema}.${snowflake_table.movie.name}
    FROM (
      SELECT
        TRY_CAST($1:id::TEXT AS INTEGER) AS ID,
        $1:title::TEXT AS TITLE,
        CASE WHEN $1:properties IS NULL THEN NULL ELSE DEV.RAW_MOVIE.GET_NAME_VALUE($1:properties)['Genre']::TEXT END AS GENRE,
        CASE WHEN $1:properties IS NULL THEN NULL ELSE TRY_CAST(DEV.RAW_MOVIE.GET_NAME_VALUE($1:properties)['Year']::TEXT as NUMBER) END AS YEAR,
        CASE WHEN $1:properties IS NULL THEN NULL ELSE TRY_CAST(DEV.RAW_MOVIE.GET_NAME_VALUE($1:properties)['Length']::TEXT AS NUMBER) END AS LENGTH,
        CASE WHEN $1:properties IS NULL THEN NULL ELSE DEV.RAW_MOVIE.GET_NAME_VALUE($1:properties)['Studio']::TEXT END AS STUDIO,
        CASE WHEN $1:properties IS NULL THEN NULL ELSE TRY_CAST(DEV.RAW_MOVIE.GET_NAME_VALUE($1:properties)['Rating']::TEXT AS NUMBER(2,1)) END AS RATING,
        CASE WHEN $1:properties IS NULL THEN NULL ELSE DEV.RAW_MOVIE.GET_NAME_VALUE($1:properties)['Language']::TEXT END AS LANGUAGE,
        CASE WHEN $1:properties IS NULL THEN NULL ELSE DEV.RAW_MOVIE.GET_NAME_VALUE($1:properties)['Country']::TEXT END AS COUNTRY,
        METADATA$FILENAME AS SOURCE_FILE,
        METADATA$FILE_ROW_NUMBER AS FILE_ROW_NUM,
        current_timestamp() AS LOADED_AT
      FROM @${snowflake_table.movie.database}.${snowflake_table.movie.schema}.${snowflake_stage.stage_movies.name}/movies
    )
    EOT

  auto_ingest       = true
  aws_sns_topic_arn = aws_sns_topic.snowflake_load_bucket_topic.arn

  depends_on = [aws_sns_topic.snowflake_load_bucket_topic, snowflake_stage.stage_movies, aws_iam_role_policy_attachment.role_for_snowflake_load_policy_attachment]
}

resource "snowflake_pipe" "snowflake_pipes" {
  #for_each = snowflake_table.snowflake_tables
  for_each = { for pipe in local.pipes : pipe.name => pipe }

  database = snowflake_schema.schema.database
  schema   = snowflake_schema.schema.name
  #name     = replace(upper("${var.stack_name}_${var.aws_region_code}_${local.pipes[index(local.pipes.*.table, each.value.name)].name}"), "-", "_")
  name    = replace(upper("${var.stack_name}_${var.aws_region_code}_${each.value.name}"), "-", "_")
  comment = "Pipe to ingest files from bucket"

  #copy_statement = local.pipes[index(local.pipes.*.table, each.value.name)].copy_stmt
  copy_statement = local.pipes[index(local.pipes.*.name, each.value.name)].copy_stmt

  auto_ingest       = true
  aws_sns_topic_arn = aws_sns_topic.snowflake_load_bucket_topic.arn
  depends_on        = [aws_sns_topic.snowflake_load_bucket_topic, snowflake_stage.stage_movies, aws_iam_role_policy_attachment.role_for_snowflake_load_policy_attachment]
}

locals {

  pipes = [
    {
      name      = "MOVIES2_PIPE"
      table     = "MOVIE2"
      copy_stmt = <<EOT
      COPY INTO ${snowflake_schema.schema.database}.${snowflake_schema.schema.name}.MOVIE2 (ID, TITLE)
      FROM (
        SELECT
          TRY_CAST($1:id::TEXT AS INTEGER) AS ID,
          $1:title::TEXT AS TITLE
        FROM @${snowflake_schema.schema.database}.${snowflake_schema.schema.name}.${snowflake_stage.stage_movies.name}/movies2
      )
      EOT
    },
    {
      name      = "ACTORS_PIPE"
      table     = "ACTOR"
      copy_stmt = <<EOT
      COPY INTO ${snowflake_schema.schema.database}.${snowflake_schema.schema.name}.ACTOR (ID, FIRST_NAME, LAST_NAME, DOB)
      FROM (
        SELECT
          TRY_CAST($1:id::TEXT AS INTEGER) AS ID,
          CASE WHEN $1:properties IS NULL THEN NULL ELSE DEV.RAW_MOVIE.GET_NAME_VALUE($1:properties)['First Name']::TEXT END AS FIRST_NAME,
          CASE WHEN $1:properties IS NULL THEN NULL ELSE DEV.RAW_MOVIE.GET_NAME_VALUE($1:properties)['Last Name']::TEXT END AS LAST_NAME,
          CASE WHEN $1:properties IS NULL THEN NULL ELSE TRY_CAST(DEV.RAW_MOVIE.GET_NAME_VALUE($1:properties)['DOB']::TEXT AS DATE) END AS DOB
        FROM @${snowflake_schema.schema.database}.${snowflake_schema.schema.name}.${snowflake_stage.stage_movies.name}/actors
      )
      EOT
    },
    {
      name      = "GENRES_PIPE"
      table     = "GENRE"
      copy_stmt = <<EOT
      COPY INTO ${snowflake_schema.schema.database}.${snowflake_schema.schema.name}.GENRE (ID, NAME)
      FROM (
        SELECT
          TRY_CAST($1:id::TEXT AS INTEGER) AS ID,
          CASE WHEN $1:properties IS NULL THEN NULL ELSE DEV.RAW_MOVIE.GET_NAME_VALUE($1:properties)['Name']::TEXT END AS NAME
        FROM @${snowflake_schema.schema.database}.${snowflake_schema.schema.name}.${snowflake_stage.stage_movies.name}/genres
      )
      EOT
    }
  ]
}
