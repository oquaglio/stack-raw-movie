
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
  comment             = lookup(each.value, "comment", null)

  dynamic "column" { # can add multiple instances of this
    for_each = { for fld in each.value.fields : fld.name => fld }

    content {
      name = column.value.name
      type = column.value.type
      # set defaults on the following attr if missing
      comment  = lookup(column.value, "comment", null)
      nullable = lookup(column.value, "nullable", true)
    }
  }
}

// apply primary keys
resource "snowflake_table_constraint" "primary_keys" {
  for_each = {
    for tbl in snowflake_table.snowflake_tables : tbl.name => tbl
    # skip table if no primary key defined
    if try(lookup(local.tables[index(local.tables.*.name, tbl.name)], "primary_key", false)) != false
  }

  name     = "PRIMARY_KEY_CONSTRAINT"
  type     = "PRIMARY KEY"
  table_id = each.value.id
  columns  = local.tables[index(local.tables.*.name, each.value.name)].primary_key
  comment  = "Primary key for ${local.tables[index(local.tables.*.name, each.value.name)].name} table"
}

resource "snowflake_tag" "tag" {
  name           = "cost_center"
  database       = snowflake_schema.schema.database
  schema         = snowflake_schema.schema.name
  allowed_values = ["finance", "engineering"]
}

#####################################
# Table locals
#####################################

locals {

  tables = [
    # if no primary key, omit primary_key key

    {
      name    = "MOVIE2"
      comment = "Movies"
      fields = [
        { name = "ID", type = "INTEGER" },
        { name = "TITLE", type = "STRING", nullable = false }
      ],
      primary_key = ["ID", "TITLE"]
    },
    {
      name    = "ACTOR"
      comment = "Actors"
      fields = [
        { name = "ID", type = "INTEGER", comment = "ID field" },
        { name = "FIRST_NAME", type = "STRING" },
        { name = "LAST_NAME", type = "STRING" },
        { name = "DOB", type = "DATE", comment = "Date of Birth" }
      ],
      primary_key = ["ID"]
    },
    {
      name    = "GENRE"
      comment = "Movie Genres"
      fields = [
        { name = "ID", type = "INTEGER", comment = "ID field" },
        { name = "NAME", type = "STRING" }
      ]
    }
  ]

  bucket_key_prefixes_for_tables = {
    "MOVIE" = "movies",
    "ACTOR" = "actors"
  }

  table_fields = flatten([
    for table in local.tables : [
      for field in table.fields : {
        table_name     = table.name
        field_name     = field.name
        field_type     = field.type
        field_nullable = lookup(field, "nullable", null)
      }
    ]
  ])

}
