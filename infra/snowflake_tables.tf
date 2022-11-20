
resource "snowflake_table" "movie_raw_payload" {
  database            = snowflake_schema.schema.database
  schema              = snowflake_schema.schema.name
  name                = "MOVIE_RAW_PAYLOAD"
  comment             = "A table for Movie RAW Payloads"
  data_retention_days = snowflake_schema.schema.data_retention_days
  change_tracking     = false

  column {
    name     = "ID"
    type     = "INTEGER"
    nullable = true
  }

  column {
    name     = "RAW_PAYLOAD"
    type     = "VARIANT"
    nullable = true
  }

  column {
    name     = "FILE_NAME"
    type     = "STRING(100)"
    nullable = true
  }

  column {
    name = "LOADED_AT"
    type = "TIMESTAMP_TZ"
  }
}

resource "snowflake_table" "movie" {
  database            = snowflake_schema.schema.database
  schema              = snowflake_schema.schema.name
  name                = "MOVIE"
  comment             = "A table for Movies"
  data_retention_days = snowflake_schema.schema.data_retention_days
  change_tracking     = false

  column {
    name     = "ID"
    type     = "INTEGER"
    nullable = true
  }

  column {
    name     = "TITLE"
    type     = "STRING"
    nullable = true
  }

  column {
    name     = "GENRE"
    type     = "STRING"
    nullable = true
  }

  column {
    name     = "YEAR"
    type     = "INTEGER"
    nullable = true
  }

  column {
    name     = "LENGTH"
    type     = "INTEGER"
    nullable = true
  }

  column {
    name     = "STUDIO"
    type     = "STRING"
    nullable = true
  }

  column {
    name     = "RATING"
    type     = "NUMBER(2,1)"
    nullable = true
  }

  column {
    name     = "LANGUAGE"
    type     = "STRING"
    nullable = true
  }

  column {
    name     = "COUNTRY"
    type     = "STRING"
    nullable = true
  }

  column {
    name     = "SOURCE_FILE"
    type     = "STRING"
    nullable = true
  }

  column {
    name     = "FILE_ROW_NUM"
    type     = "NUMBER(38,0)"
    nullable = true
  }

  column {
    name = "LOADED_AT"
    type = "TIMESTAMP_TZ"
  }

}



resource "snowflake_table" "snowflake_tables" {

  for_each = { for tbl in local.tables : tbl.name => tbl }

  database            = snowflake_schema.schema.database
  schema              = snowflake_schema.schema.name
  data_retention_days = snowflake_schema.schema.data_retention_days
  change_tracking     = false
  name                = each.key

  column {
    name = "test"
    type = "INTEGER"
  }

}

#####################################
# Table definitions
#####################################

locals {

  tables = [
    {
      name    = "MOVIE2"
      comment = "A table for Movies"
      fields = [
        { name = "ID", type = "INTEGER", nullable = true },
        { name = "TITLE", type = "INTEGER", nullable = true }
      ]
    },
    {
      name    = "ACTOR"
      comment = "A table for Actors"
      fields = [
        { name = "ID", type = "INTEGER", nullable = true },
        { name = "FIRST_NAME", type = "STRING", nullable = true },
        { name = "LAST_NAME", type = "STRING", nullable = true },
        { name = "DOB", type = "DATE", nullable = true }
      ]
    }
  ]

  bucket_key_prefixes = {
    "MOVIE" = "movies",
    "ACTOR" = "actors"
  }

}
